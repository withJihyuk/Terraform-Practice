variable "enable_db" {
  description = "Enable RDS"
  type        = bool
  default     = false
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "rds_security_group_id" {
  description = "RDS security group ID"
  type        = string
  default     = null
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_engine" {
  description = "DB engine"
  type        = string
  default     = "mysql"
}

variable "db_instance_type" {
  description = "RDS instance type"
  type        = string
}

variable "db_allocated_storage" {
  description = "RDS allocated storage"
  type        = number
}

variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "db_username" {
  description = "RDS database username"
  type        = string
}

variable "db_password" {
  description = "RDS database password"
  type        = string
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

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
} 