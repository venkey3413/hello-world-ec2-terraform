provider "aws" {
  region = "us-east-1"  
}

resource "aws_ecs_cluster" "cluster" {
  name = "hello-world-nodejs-cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "hello-world-nodejs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "hello-world-nodejs-container"
      image     = "f86c6492a6bc"  # Update with your Docker image URL
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = "hello-world-nodejs-service"
  cluster         = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-05d87a98545cd0c56"]  # Update with your subnet ID
    security_groups = ["sg-0561a79cc8203131b"]  # Update with your security group ID
    assign_public_ip = true
  }
}
