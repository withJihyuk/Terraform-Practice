# Infrastructure outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.infrastructure.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.infrastructure.vpc_cidr_block
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.infrastructure.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.infrastructure.private_subnets
}

# Compute outputs
output "ec2_ip" {
  description = "Public IP address of the Minecraft server"
  value       = module.compute.public_ip
}

output "ec2_instance_id" {
  description = "Instance ID of the Minecraft server"
  value       = module.compute.instance_id
}

output "spot_request_id" {
  description = "Spot instance request ID"
  value       = module.compute.spot_request_id
}

output "ebs_volume_id" {
  description = "EBS volume ID for Minecraft data"
  value       = module.compute.ebs_volume_id
}

# Database outputs
output "db_endpoint" {
  description = "RDS endpoint (if enabled)"
  value       = module.database.db_endpoint
}

# Security outputs  
output "minecraft_security_group_id" {
  description = "ID of the minecraft security group"
  value       = module.security.minecraft_sg_id
}

# Monitoring outputs
output "sns_topic_arn" {
  description = "SNS topic ARN for alerts"
  value       = module.monitoring.sns_topic_arn
}