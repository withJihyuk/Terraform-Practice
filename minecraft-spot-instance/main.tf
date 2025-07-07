# Infrastructure module - VPC and networking
module "infrastructure" {
  source = "./modules/infrastructure"

  vpc_name             = local.vpc_name
  vpc_cidr             = local.vpc_cidr
  availability_zones   = local.availability_zones
  private_subnet_cidrs = local.private_subnet_cidrs
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_names = local.private_subnet_names
  public_subnet_names  = local.public_subnet_names
  common_tags          = local.common_tags
}

# Security module
module "security" {
  source = "./modules/security"

  vpc_id      = module.infrastructure.vpc_id
  mc_port     = var.mc_port
  enable_db   = var.enable_db
  db_port     = var.db_port
  common_tags = local.common_tags
}

# Compute module
module "compute" {
  source = "./modules/compute"

  region                      = var.region
  availability_zone           = var.availability_zone
  instance_type               = var.instance_type
  ami_id                      = var.ami_id
  key_name                    = var.key_name
  public_subnet_id            = module.infrastructure.public_subnets[0]
  security_group_id           = module.security.minecraft_sg_id
  associate_public_ip_address = var.associate_public_ip_address
  volume_size                 = var.volume_size
  volume_type                 = var.volume_type
  common_tags                 = local.common_tags
}

# Database module
module "database" {
  source = "./modules/database"

  enable_db              = var.enable_db
  private_subnet_ids     = module.infrastructure.private_subnets
  rds_security_group_id  = module.security.rds_sg_id
  db_identifier          = var.db_identifier
  db_engine              = var.db_engine
  db_instance_type       = var.db_instance_type
  db_allocated_storage   = var.db_allocated_storage
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  db_port                = var.db_port
  multi_az               = var.multi_az
  common_tags            = local.common_tags
}

# Monitoring module
module "monitoring" {
  source = "./modules/monitoring"

  discord_webhook_url = var.discord_webhook_url
  instance_id         = module.compute.instance_id
  common_tags         = local.common_tags
} 