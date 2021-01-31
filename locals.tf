##
## Local_file resource, used in order to create the config.py for our rates app
##
resource "local_file" "local" {
  content = format("DB = { 'name': '%s', 'user': '%s', 'password': '%s','host': '%s'}", var.rds_database_name, var.rds_username, var.rds_password,aws_db_instance.main.address)
  filename = "rates/config.py"
}

##
## null_resource used in order to run the script which will:
## - Load database dumps.
## - Build and push Docker image to ECR with latest tag
##
resource "null_resource" "load_data" {

  triggers = {
    always_run = format(timestamp())
  }

  provisioner "local-exec" {
    command =  format("./load_postgres_dump.sh %s %s %s %s %s", aws_db_instance.main.address, aws_db_instance.main.port, var.rds_username, var.rds_password, var.rds_database_name )
  }

  provisioner "local-exec" {
    command = format("./build_push_docker_image.sh %s", aws_ecr_repository.main.repository_url)
  }

}
