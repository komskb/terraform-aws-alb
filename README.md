# KOMSKB Framework Terraform AWS-ALB module 

AWS ALB를 생성하는 Terraform 모듈 입니다.

내부적으로 사용하는 리소스 및 모듈:

* [ALB](https://github.com/terraform-aws-modules/terraform-aws-alb)
* [Security Group](https://github.com/terraform-aws-modules/terraform-aws-security-group)

## Usage

```hcl
module "alb" {
  source = "komskb/alb/aws"

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
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| api\_port | Local port service should be running on. Default value is most likely fine. | string | `"5000"` | no |
| certificate\_arn | certificate arn | string | `""` | no |
| environment | Deploy environment | string | `"production"` | no |
| ingress\_cidr\_blocks | List of IPv4 CIDR ranges to use on all ingress rules of the ALB. | list(string) | `[ "0.0.0.0/0" ]` | no |
| project | Project name to use on all resources created (VPC, ALB, etc) | string | n/a | yes |
| subnet\_ids | A list of IDs of existing public subnets inside the VPC | list(string) | `[]` | no |
| tags | A map of tags to use on all resources | map(string) | `{}` | no |
| vpc\_id | ID of an existing VPC where resources will be created | string | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| dns\_name | The DNS name of the load balancer |
| id | The ID of the load balancer |
| security\_group\_id | security group id |
| target\_group\_arns | Target group arns of the load balancer |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Authors

Module is maintained by [komskb](https://github.com/komskb).

## License

MIT licensed. See LICENSE for full details.
