resource "aws_ecs_cluster" "cluster" {
  name = "helloweb-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name          = aws_ecs_cluster.cluster.name
  capacity_providers    = ["FARGATE"]

  default_capacity_provider_strategy {
    base                = 1
    weight              = 100
    capacity_provider   = "FARGATE"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name              = "helloweb-service"
  cluster           = aws_ecs_cluster.cluster.id
  task_definition   = aws_ecs_task_definition.ecs_task.arn
  launch_type       = "FARGATE"
  desired_count     = 1

  network_configuration {
    security_groups  = [aws_security_group.allow_http_in.id, aws_security_group.allow_all_out.id]
    subnets          = [var.subnet1_id, var.subnet2_id] # Hard coded subnet ids. Use 2 of the subnets already created
    assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 2048
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "nginx",
      "image"     : "nginx:1.23.2",
      "cpu"       : 512,
      "memory"    : 2048,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort"      : 80
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_security_group" "allow_http_in" {
  name        = "allow_http_in"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "allow_all_out" {
  name        = "allow_all_out"
  description = "All outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    description      = "ALL"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}