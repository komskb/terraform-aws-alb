# KOMSKB Framework Terraform AWS-ALB module 

AWS ALB를 생성하는 Terraform 모듈 입니다.

내부적으로 사용하는 리소스 및 모듈:

* [ALB](https://github.com/terraform-aws-modules/terraform-aws-alb)
* [Security Group](https://github.com/terraform-aws-modules/terraform-aws-security-group)

## Usage

```hcl
module "alb" {
  source = "komskb/terraform-module-alb"

  project = "${var.project}"
  environment = "${var.environment}"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_ids = ["${module.vpc.public_subnets}"]
  ingress_cidr_blocks = ["${var.alb_ingress_cidrs}"]
  certificate_arn = "${data.aws_acm_certificate.this.arn}"
  api_port = "${var.api_port}"

  tags = {
    Terraform = "${var.terraform_repo}"
    Environment = "${var.environment}"
  }
}
```

## Terraform version

Terraform version 0.11.13 or newer is required for this module to work.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Authors

Module is maintained by [komskb](https://github.com/komskb).

## License

MIT licensed. See LICENSE for full details.