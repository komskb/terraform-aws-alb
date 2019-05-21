locals {
  tags = "${merge(var.tags, map("Project", var.project))}"
}

data "aws_region" "current" {}

###################
# ALB
###################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "v3.5.0"

  load_balancer_name = "${format("%s-%s-alb", var.project, var.environment)}"

  vpc_id          = "${var.vpc_id}"
  subnets         = ["${var.subnet_ids}"]
  security_groups = ["${module.alb_https_sg.this_security_group_id}", "${module.alb_http_sg.this_security_group_id}"]
  logging_enabled = false

  https_listeners_count = 1

  https_listeners = [
    {
      port            = 443
      certificate_arn = "${var.certificate_arn}"
    },
  ]

  http_tcp_listeners_count = 1

  http_tcp_listeners = [
    {
      port     = 80
      protocol = "HTTP"
    },
  ]

  target_groups_count = 1

  target_groups = [
    {
      name                 = "${format("%s-%s-api", var.project, var.environment)}"
      backend_protocol     = "HTTP"
      backend_port         = "${var.api_port}"
      target_type          = "ip"
      deregistration_delay = 10
    },
  ]

  tags = "${merge(local.tags, map("Name", format("%s-%s-alb", var.project, var.environment)))}"
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = "${module.alb.http_tcp_listener_arns[0]}"

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "path-pattern"
    values = ["*"]
  }
}

###################
# Security groups
###################
module "alb_https_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "v2.14.0"

  name        = "${format("%s-%s-alb-https-sg", var.project, var.environment)}"
  vpc_id      = "${var.vpc_id}"
  description = "Security group with HTTPS ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = "${var.ingress_cidr_blocks}"

  tags = "${merge(local.tags, map("Name", format("%s-%s-alb-https-sg", var.project, var.environment)))}"
}

module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "v2.14.0"

  name        = "${format("%s-%s-alb-http-sg", var.project, var.environment)}"
  vpc_id      = "${var.vpc_id}"
  description = "Security group with HTTP ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = "${var.ingress_cidr_blocks}"

  tags = "${merge(local.tags, map("Name", format("%s-%s-alb-http-sg", var.project, var.environment)))}"
}

module "default_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "v2.14.0"

  name        = "${format("%s-%s-ecs-sg", var.project, var.environment)}"
  vpc_id      = "${var.vpc_id}"
  description = "Security group with open port for api (${var.api_port}) from ALB, egress ports are all world open"

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = "${var.api_port}"
      to_port                  = "${var.api_port}"
      protocol                 = "tcp"
      description              = "${format("%s %s default security group", var.project, var.environment)}"
      source_security_group_id = "${module.alb_https_sg.this_security_group_id}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = "${merge(local.tags, map("Name", format("%s-%s-ecs-sg", var.project, var.environment)))}"
}
