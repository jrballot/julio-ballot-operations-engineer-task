##
## AWS Variables
##
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region to be used"
}

variable "az_count" {
  type = number
  default = 3
  description = "Number of regions to be created"
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
  default     = ["192.168.200.0/24","192.168.201.0/24","192.168.202.0/24"]
  description = "AWS VPC public network"
}
variable "private_subnets" {
  default     = ["192.168.100.0/24","192.168.101.0/24","192.168.102.0/24"]
  description = "AWS EKS private networks"
}

##
## AWS ECS Cluster
##
variable "ecs_cluster_name" {
  default = "operations_task_ecs_cluster"
  description = "AWS ECS cluster name"
}
variable "ecs_service_name" {
  default = "operations_task"
  description = "AWS ECS Service name"
}

##
## AWS ECS Contiainers variables
##
variable "containers_port" {
  type = number
  default = 3000
  description = "AWS ECS container's port"
}
variable "containers_name" {
  type = string
  default = "operations-task-app"
  description = "Containers name to be used"
}
variable "containers_cpu" {
  type = number
  default = 256
  description = "AWS ECS container's cpu"
}
variable "containers_memory" {
  type = number
  default = 512
  description = "AWS ECS container's memory"
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
  default     = "postgres"
  description = "RDS Username"
}
variable "rds_password" {
  type        = string
  default     = "postgres"
  description = "RDS Password"
}
variable "rds_disk_size" {
  type = number
  default = 5
  description = "RDS Disk Size in GiB"
}
variable "rds_storage_type" {
  type = string
  default =  "gp2"
  description = "RDS Storage Type"
}

##
## AWS ECR Variables
##
variable "ecr_repository_name" {
  type = string
  default = "operations-task-repo"
  description = "AWS ECR Operations Task repository name"
}
variable "ecr_image_tag_mutability" {
  type = string
  default = "MUTABLE"
  description = "AWS ECR Image Tag Mutability"
}
variable "ecr_image_scan_config" {
  type = string
  default = "true"
  description = "AWS ECR Image Scan Configuration"
}
