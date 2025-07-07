locals {
  # Common naming
  project_name = "minecraft"
  environment  = "prod"
  
  # Common tags
  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    Terraform   = "true"
    ManagedBy   = "terraform"
  }
  
  # Naming conventions
  resource_prefix = "${local.project_name}-${local.environment}"
  
  # Network configuration
  vpc_name = "${local.resource_prefix}-vpc"
  vpc_cidr = "10.0.0.0/16"
  
  # Availability zones based on region
  availability_zones = [
    "${var.region}a",
    "${var.region}c"
  ]
  
  # Subnet configurations
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24"]
  
  private_subnet_names = [
    "${local.resource_prefix}-private-subnet-a",
    "${local.resource_prefix}-private-subnet-b"
  ]
  public_subnet_names = [
    "${local.resource_prefix}-public-subnet-a"
  ]
} 