output "security_group_id" {
  description = "security group id"
  value       = module.default_sg.this_security_group_id
}

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb.dns_name
}

output "id" {
  description = "The ID of the load balancer"
  value       = module.alb.load_balancer_id
}

output "target_group_arns" {
  description = "Target group arns of the load balancer"
  value       = module.alb.target_group_arns
}

