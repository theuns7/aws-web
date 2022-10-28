output "ecs_cluster" {
  value = aws_ecs_cluster.cluster
}

output "ecs_service" {
  value = aws_ecs_service.ecs_service
}