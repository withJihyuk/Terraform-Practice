# Security Group for Minecraft server
resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-security-group"
  description = "Security group for Minecraft server"
  vpc_id      = var.vpc_id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Minecraft port
  ingress {
    from_port   = var.mc_port
    to_port     = var.mc_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "minecraft-security-group"
  })
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  count       = var.enable_db ? 1 : 0
  name        = "minecraft-rds-security-group"
  description = "Security group for Minecraft RDS"
  vpc_id      = var.vpc_id

  # Database access from EC2
  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.minecraft_sg.id]
  }

  tags = merge(var.common_tags, {
    Name = "minecraft-rds-security-group"
  })
} 