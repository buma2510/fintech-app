resource "aws_ecs_cluster" "main" {
  name = "fintech-app-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                = "fintech-app-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"
  execution_role_arn    = aws_iam_role.ecs_task_execution.arn
  container_definitions = jsonencode([
    {
      name      = "fintech-app"
      image     = "${aws_ecr_repository.app.repository_url}:latest"
      essential = true
      portMappings = [{ containerPort = 80, hostPort = 80, protocol = "tcp" }]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "fintech-app-svc"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = aws_subnet.public[*].id
    assign_public_ip = true
  }
}
