variable "project" {
  description = "Project name to use on all resources created (VPC, ALB, etc)"
  type        = string
}

variable "environment" {
  description = "Deploy environment"
  type        = string
  default     = "production"
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

# VPC
variable "vpc_id" {
  description = "ID of an existing VPC where resources will be created"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A list of IDs of existing public subnets inside the VPC"
  type        = list(string)
  default     = []
}

# ALB
variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules of the ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# ACM
variable "certificate_arn" {
  description = "certificate arn"
  type        = string
  default     = ""
}

variable "api_port" {
  description = "Local port service should be running on. Default value is most likely fine."
  default     = 5000
}

