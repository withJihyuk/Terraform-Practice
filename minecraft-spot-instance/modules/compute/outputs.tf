output "instance_id" {
  description = "Instance ID"
  value       = data.aws_instance.minecraft_server.id
}

output "public_ip" {
  description = "Public IP"
  value       = data.aws_instance.minecraft_server.public_ip
}

output "spot_request_id" {
  description = "Spot request ID"
  value       = aws_spot_instance_request.minecraft_server.id
}

output "ebs_volume_id" {
  description = "EBS volume ID"
  value       = aws_ebs_volume.minecraft_data.id
} 