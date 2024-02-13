resource "aws_ecs_cluster" "test_app_ecs_cluster" {
  name = var.test_app_ecs_cluster_name
}

resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = var.availability_zones[0]
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = var.availability_zones[1]
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = var.availability_zones[2]
}

resource "aws_ecs_task_definition" "test_app_task" {
  family                   = var.test_app_task_family
  container_definitions    = <<DEFINITION
[
  {
    "name": "${var.test_app_container_name}",
    "image": "${var.ecr_repository_url}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.test_app_container_port},
        "hostPort": ${var.test_app_container_port}
      }
    ],
    "memory": ${var.test_app_container_memory},
    "cpu": ${var.test_app_container_cpu},
    "environment": [
      {
        "name": "PORT",
        "value": "${var.test_app_container_port}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${var.test_app_ecs_cluster_name}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.test_app_container_memory
  cpu                      = var.test_app_container_cpu
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_alb" "test_app_alb" {
  name               = var.test_app_alb_name
  load_balancer_type = "application"
  subnets            = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id, aws_default_subnet.default_subnet_c.id] //maybe this subnets should go inside string template
  security_groups    = [aws_security_group.load_balancer_security_group.id]
}

resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "test_app_alb_target_group" {
  name        = var.test_app_alb_target_group_name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id
}

resource "aws_lb_listener" "test_app_alb_listener" {
  load_balancer_arn = aws_alb.test_app_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_app_alb_target_group.arn
  }
}

resource "aws_ecs_service" "test_app_ecs_service" {
  name            = var.test_app_ecs_service_name
  cluster         = aws_ecs_cluster.test_app_ecs_cluster.id
  task_definition = aws_ecs_task_definition.test_app_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.test_app_ecs_service_desired_count
  load_balancer {
    target_group_arn = aws_lb_target_group.test_app_alb_target_group.arn
    container_name   = var.test_app_container_name
    container_port   = var.test_app_container_port
  }
  network_configuration {
    subnets          = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id, aws_default_subnet.default_subnet_c.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.service_security_group.id]
  }
}

resource "aws_security_group" "service_security_group" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    security_groups = [
      aws_security_group.load_balancer_security_group.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
