output "aws_rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "aws_ecr_endpoint" {
  value = aws_ecr_repository.main.repository_url
}

output "aws_alb_endpoint" {
  value = aws_alb.frontend.dns_name
}
