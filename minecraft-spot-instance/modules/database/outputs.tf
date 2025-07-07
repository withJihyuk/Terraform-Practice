output "db_endpoint" {
  description = "RDS endpoint"
  value       = var.enable_db ? aws_db_instance.minecraft_db[0].endpoint : null
}

output "db_port" {
  description = "RDS port"
  value       = var.enable_db ? aws_db_instance.minecraft_db[0].port : null
} 