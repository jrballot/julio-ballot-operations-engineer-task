#resource "aws_db_parameter_group" "main" {
#  name   = "postgresql"
#  family = "postgres9.6"
#}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = aws_subnet.public[*].id
}

resource "aws_db_instance" "main" {
  allocated_storage    = var.rds_disk_size
  storage_type         = var.rds_storage_type
  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_class
  name                 = var.rds_database_name
  username             = var.rds_username
  password             = var.rds_password
  #parameter_group_name = aws_db_parameter_group.main.name
  db_subnet_group_name = aws_db_subnet_group.main.name
  multi_az             = false
  skip_final_snapshot  = true

  vpc_security_group_ids = list(aws_security_group.postgres.id)
  publicly_accessible = true
}
