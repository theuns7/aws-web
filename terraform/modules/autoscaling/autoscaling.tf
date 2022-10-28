resource "aws_appautoscaling_target" "as_target" {
  max_capacity = 10
  min_capacity = 2
  resource_id = "service/${var.ecs_cluster.name}/${var.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "ap_memory" {
  name               = "ap-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.as_target.resource_id
  scalable_dimension = aws_appautoscaling_target.as_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.as_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
  }
}

resource "aws_appautoscaling_policy" "ap_cpu" {
  name = "ap-cpu"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.as_target.resource_id
  scalable_dimension = aws_appautoscaling_target.as_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.as_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}