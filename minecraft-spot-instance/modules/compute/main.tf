# IAM Role for EC2 instance
resource "aws_iam_role" "minecraft_ec2_role" {
  name = "minecraft-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for EC2 instance
resource "aws_iam_policy" "minecraft_ec2_policy" {
  name        = "minecraft-ec2-policy"
  description = "Policy for Minecraft EC2 instance"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeVolumes",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:DescribeInstances",
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "minecraft_ec2_policy_attachment" {
  role       = aws_iam_role.minecraft_ec2_role.name
  policy_arn = aws_iam_policy.minecraft_ec2_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "minecraft_ec2_profile" {
  name = "minecraft-ec2-profile"
  role = aws_iam_role.minecraft_ec2_role.name
}

# EBS Volume for Minecraft data
resource "aws_ebs_volume" "minecraft_data" {
  availability_zone = var.availability_zone
  size              = var.volume_size
  type              = var.volume_type
  encrypted         = true

  tags = merge(var.common_tags, {
    Name = "minecraft-data-volume"
  })
}

# EC2 Spot Instance
resource "aws_spot_instance_request" "minecraft_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.minecraft_ec2_profile.name
  availability_zone           = var.availability_zone

  # Spot instance configuration
  spot_price                          = "0.1"
  wait_for_fulfillment                = true
  spot_type                           = "one-time"
  instance_interruption_behavior      = "terminate"

#   user_data = base64encode(templatefile("${path.module}/user_data.sh", {
#     ebs_volume_id = aws_ebs_volume.minecraft_data.id
#     region        = var.region
#   }))

  tags = merge(var.common_tags, {
    Name = "minecraft-spot-instance"
  })
}

# Data source to get the actual instance
data "aws_instance" "minecraft_server" {
  depends_on = [aws_spot_instance_request.minecraft_server]
  
  filter {
    name   = "spot-instance-request-id"
    values = [aws_spot_instance_request.minecraft_server.id]
  }
} 