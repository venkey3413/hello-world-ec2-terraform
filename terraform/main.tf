provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "cluster" {
  name = "hello-world-nodejs-cluster"
}

variable "image_url" {}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    "Version" => "2012-10-17",
    "Statement" => [{
      "Effect"    => "Allow",
      "Principal" => {
        "Service" => "ecs-tasks.amazonaws.com"
      },
      "Action"    => "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "hello-world-nodejs-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = <<DEFINITION
[
  {
    "name": "hello-world-nodejs",
    "image": "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}",
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
