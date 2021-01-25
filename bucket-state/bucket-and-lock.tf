provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.aws_s3_bucket_name
  
  # Allow versioning so our state can have multiple versions
  versioning {
    enabled = true
  }
 
  # Encrypt the bucket
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Prevent destruction if by mistake some run terraform destroy
  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_dynamodb_table" "terraform_lock" {
  name = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"  

  attribute {
    name = "LockID"
    type = "S"
  }

  # Prevent destruction if by mistake some run terraform destroy
  lifecycle {
    prevent_destroy = true
  }
}
