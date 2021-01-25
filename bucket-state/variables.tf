##
## AWS Region definition
##
variable "aws_region" {
  type = string
  default = "us-east-1"
  description = "AWS Region to be used"
}


##
## AWS S3 bucket name
##
variable "aws_s3_bucket_name" {
  type = string 
  default = "operations-task-tf-state"
  description = "AWS S3 for Terraform state"
}

##
## AWS DynamoDB table's name
##
variable "lock_table_name" {
  type = string
  default = "tf-lock-table"
  description = "AWS DynamoDB table for Terraform locks"
}
