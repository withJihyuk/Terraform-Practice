# RDS Subnet Group
resource "aws_db_subnet_group" "minecraft_db_subnet_group" {
  count      = var.enable_db ? 1 : 0
  name       = "minecraft-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.common_tags, {
    Name = "minecraft-db-subnet-group"
  })
}

# RDS Instance
resource "aws_db_instance" "minecraft_db" {
  count                  = var.enable_db ? 1 : 0
  identifier             = var.db_identifier
  engine                 = var.db_engine
  engine_version         = var.db_engine == "mysql" ? "8.0" : "13.7"
  instance_class         = var.db_instance_type
  allocated_storage      = var.db_allocated_storage
  storage_type           = "gp3"
  storage_encrypted      = true
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  vpc_security_group_ids = var.rds_security_group_id != null ? [var.rds_security_group_id] : []
  db_subnet_group_name   = aws_db_subnet_group.minecraft_db_subnet_group[0].name

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  multi_az               = var.multi_az
  publicly_accessible    = false
  
  skip_final_snapshot = true
  deletion_protection = false

  tags = merge(var.common_tags, {
    Name = "minecraft-database"
  })
} 