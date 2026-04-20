resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.project_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name      = "app"
    image     = var.container_image
    essential = true
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
    environment = [
      { name = "TABLE_NAME", value = var.table_name },
      { name = "AWS_REGION", value = var.aws_region }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = var.log_group_name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_tasks.id]
  }
}

resource "aws_lb" "internal" {
  name               = "${var.project_name}-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnets
}

resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-tg"
  port        = var.container_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol = "TCP"
    port     = var.container_port
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = var.container_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_ecs_service" "this" {
  name = "app"

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "app"
    container_port   = var.container_port
  }
}
