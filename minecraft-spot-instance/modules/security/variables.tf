variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "mc_port" {
  description = "Minecraft server port"
  type        = number
  default     = 25565
}

variable "enable_db" {
  description = "Enable RDS"
  type        = bool
  default     = false
}

variable "db_port" {
  description = "RDS port"
  type        = number
  default     = 3306
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
} 