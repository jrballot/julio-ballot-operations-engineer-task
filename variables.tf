##
## AWS Variables
##
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region to be used"
}


##
## AWS VPC variables
##
variable "vpc_cidr_block" {
  type        = string
  default     = "192.168.0.0/16"
  description = "AWS VPC cidr block"
}
variable "public_subnets" {
  default     = "192.168.200.0/24"
  description = "AWS VPC public network"
}
variable "private_subnets" {
  default     = "192.168.100.0/24"
  description = "AWS EKS private networks"
}


##
## AWS RDS Variables
##
variable "rds_database_name" {
  type        = string
  default     = "rates"
  description = "RDS PostgreSQL database name"
}
variable "rds_engine" {
  type        = string
  default     = "postgres"
  description = "RDS Database engine"
}
variable "rds_engine_version" {
  type        = string
  default     = "9.6"
  description = "RDS Database Engine version"
}
variable "rds_instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "RDS Instance class to be used"
}
variable "rds_username" {
  type        = string
  default     = "ballot"
  description = "RDS Username"
}
variable "rds_password" {
  type        = string
  default     = "ballot123"
  description = "RDS Password"
}
variable "rds_disk_size" {
  type = number
  default = 5
  description = "RDS Disk Size in GiB"
}
