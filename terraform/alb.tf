resource "aws_alb" "alb" {
  name               = "aws-web-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups    = [aws_security_group.allow_http_in.id, aws_security_group.allow_all_out.id]
  subnets            = [var.subnet1_id, var.subnet2_id] # Hard coded subnet ids. Use 2 of the subnets already created
}

resource "aws_lb_target_group" "lb_target_group" {
  name        = "tg-aws-web"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled = true
    path    = "/health.html"
  }

  depends_on = [aws_alb.alb]
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

output "aws_web_url" {
  value = "http://${aws_alb.alb.dns_name}"
}