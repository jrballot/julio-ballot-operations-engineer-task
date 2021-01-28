[
  {
    "name": "operations-task-app",
    "image": "${aws_ecr_repository}:${tag}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000,
        "protocol": "tcp"
      }
    ],
    "cpu": 256,
    "memory": 512
  }
]
