output "alb" {
  value = aws_alb.alb
}

output "ecs_target_group" {
  value = aws_lb_target_group.lb_target_group
}

output "aws_web_url" {
  value = "http://${aws_alb.alb.dns_name}"
}