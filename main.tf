provider "aws" {
  region = var.aws_region
}


##
## Terraform backend definition
##
terraform {
  backend "s3" {
    bucket         = "operations-task-tf-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-lock-table"
    encrypt        = true
  }
}



