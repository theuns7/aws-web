data "aws_iam_policy_document" "task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "aws_web_ecs_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_pa" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "cluster" {
  name = "aws-web-cluster"
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
  name              = "aws-web-service"
  cluster           = aws_ecs_cluster.cluster.id
  task_definition   = aws_ecs_task_definition.ecs_task.arn
  launch_type       = "FARGATE"
  desired_count     = 2

  lifecycle {
      ignore_changes = [desired_count]
    }

  network_configuration {
    security_groups  = [aws_security_group.allow_http_in.id, aws_security_group.allow_all_out.id]
    subnets          = [var.subnet1_id, var.subnet2_id] # Hard coded subnet ids. Use 2 of the subnets already created
    assign_public_ip = true
  }

    load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "aws-web"
    container_port   = "80"
  }
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "aws-web",
      "image"     : "980318628917.dkr.ecr.us-east-1.amazonaws.com/aws-web:latest",
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