resource "aws_ecr_repository" "main" {
  name = var.ecr_repository_name
  image_tag_mutability = var.ecr_image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr_image_scan_config
  }
}


