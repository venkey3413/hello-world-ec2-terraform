# main.tf
provider "aws" {
  region = "us-east-1"  # Specify your region
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster"  # Specify your cluster name
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "my-ecs-task"
  container_definitions    = <<DEFINITION
[
  {
    "name": "my-node-app",
    "image": "${docker_image}",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-05d87a98545cd0c56"]  # Specify your subnet ID
    security_groups = ["sg-0561a79cc8203131b"]      # Specify your security group ID
    assign_public_ip = true
  }
}
