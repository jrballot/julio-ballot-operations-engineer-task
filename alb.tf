resource "aws_alb" "frontend" {
  name = "alb-public"
  internal = false
  load_balancer_type = "application"
  subnets = aws_subnet.public[*].id
  security_groups = [aws_security_group.lb.id] 
}


resource "aws_alb_target_group" "app" {
  name = "alb-target-group"
  port = 3000
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "frontend" {
  load_balancer_arn = aws_alb.frontend.id
  port = 3000
  protocol = "HTTP"
   
  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type = "forward"
  }
}
