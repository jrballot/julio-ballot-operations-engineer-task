##
## AWS ECS Cluster: Defining cluster name
##
resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
  capacity_providers = ["FARGATE"]

  
}

##
## AWS ECS Service definition
##
## Used to define how to run tasks on ECS cluster
##
resource "aws_ecs_service" "frontend" {
  name = var.ecs_service_name
  cluster = aws_ecs_cluster.main.id
  task_definition =  aws_ecs_task_definition.service.arn
  desired_count = 1
  launch_type = "FARGATE"
  force_new_deployment = "true"

  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets = aws_subnet.public[*].id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name =  var.containers_name
    container_port = var.containers_port
  }

  depends_on = [aws_alb_listener.frontend,aws_iam_role_policy_attachment.ecs_task_execution_role]
}

##
## AWS ECS Task definition
##
## Used to define task with containers configuration and hw resources, e.g. CPU, MEMORY
##
resource "aws_ecs_task_definition" "service" {
  family                   = "operations-task-app"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn		   = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.operations_task.rendered
}

##
## AWS ECS Task Template
##

data "template_file" "operations_task" {
  template = file("./operations-app.json.tpl")
  vars = {
    aws_ecr_repository = aws_ecr_repository.main.repository_url
    tag                = "latest"
    app_port           = var.containers_port
    app_name	       = var.containers_name
    app_cpu            = var.containers_cpu
    app_memory         = var.containers_memory
  }
}
