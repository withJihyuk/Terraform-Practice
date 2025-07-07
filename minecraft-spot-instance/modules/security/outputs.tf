output "minecraft_sg_id" {
  description = "ID of the minecraft security group"
  value       = aws_security_group.minecraft_sg.id
}

output "rds_sg_id" {
  description = "ID of the RDS security group"
  value       = var.enable_db ? aws_security_group.rds_sg[0].id : null
} 