resource "aws_ecs_cluster" "main" {
  name = "dev-cluster"
}

data "aws_subnet_ids" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_ecs_service" "dev" {
  name = "development"
  cluster = aws_ecs_cluster.main.id
  task_definition =  aws_ecs_task_definition.service.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets = aws_subnet.public[*].id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name = "operations-task-app"
    container_port = 3000
  }

  depends_on = [aws_alb_listener.frontend,aws_iam_role_policy_attachment.ecs_task_execution_role]
}


data "template_file" "operations_task" {
  template = file("./operations-app.json.tpl")
  vars = {
    aws_ecr_repository = aws_ecr_repository.main.repository_url
    tag                = "latest"
    app_port           = 3000
  }
}

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
