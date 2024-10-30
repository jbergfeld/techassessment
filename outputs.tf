# Output variable definitions
output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  description = "IDs of the VPC's private subnets"
  value       = module.vpc.private_subnets
}

#output "ec2_instance_public_ips" {
#  description = "Public IP addresses of EC2 instances"
#  value       = module.ec2_instances[*].public_ip
#}

