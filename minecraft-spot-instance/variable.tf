variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "availability_zone" {
  description = "AWS availability zone"
  type        = string
  default     = "ap-northeast-2a"
}

variable "discord_webhook_url" {
  description = "Discord webhook url"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "m6g.large"
}

variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
  default     = "ami-09ed9bca6a01cd74a"
}

variable "key_name" {
  description = "pre-existing SSH key pair name"
  type        = string
  default     = "minecraft-key"
}

variable "mc_port" {
  description = "Minecraft server port"
  type        = number
  default     = 25565
}

variable "associate_public_ip_address" {
  description = "Associate public IP address"
  type        = bool
  default     = true
}

variable "volume_size" {
  description = "EBS volume size"
  type        = number
  default     = 30
}

variable "volume_type" {
  description = "EBS volume type"
  type        = string
  default     = "gp3"
}

variable "enable_db" {
  description = "Enable RDS"
  type        = bool
  default     = false
}

variable "db_engine" {
  description = "DB engine"
  type        = string
  default     = "mysql"
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "minecraft-db"
}

variable "db_instance_type" {
  description = "RDS instance type"
  type        = string
  default     = "db.t2.micro"
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "minecraft"
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  default     = "minecraft"
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  default     = "password1234!"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage"
  type        = number
  default     = 20
}

variable "db_port" {
  description = "RDS port"
  type        = number
  default     = 3306
}

variable "multi_az" {
  description = "RDS multi-AZ"
  type        = bool
  default     = false
}

