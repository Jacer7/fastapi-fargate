#################################################
#                   ECS Cluster                 #
#################################################
resource "aws_ecs_cluster" "ECS_Cluster" {
  name = "fastapi-ecs-cluster"
  setting {
    name  = "containerInsights" # For CloudWatch Container Insights
    value = "enabled"
  }
  tags = merge(
    local.common_tags,
    {
      Name = upper("fastapi-ecs-cluster")
    },
  )
}


resource "aws_ecs_cluster_capacity_providers" "ecs_capacity_strategy" {
  cluster_name = aws_ecs_cluster.ECS_Cluster.name

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100 # Prefer Fargate Spot as much as possible
    capacity_provider = "FARGATE_SPOT"
  }
  # Fallback to Fargate when Fargate Spot is unavailable
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 0 # No tasks are required to run on Fargate
    weight            = 1 # Lower weight for fallback to Fargate
  }

}

###################################################
#               ECS Task Definition               #
###################################################
resource "aws_ecs_task_definition" "fargate_task" {
  family                   = "fastapi-service"
  network_mode             = "awsvpc"                                 # Required for Fargate
  requires_compatibilities = ["FARGATE"]                              # Specify Fargate service
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn # Execution role for pulling image and logging
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn # Task role for permissions needed by the app
  cpu                      = "512"                                    # 512 vCPU units
  memory                   = "1024"                                   # 1GB of memory

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  tags = merge(local.common_tags,
    {
      Name = upper("fastapi-ecs-task-defination")
    }
  )

  # Container definition using ECR image
  container_definitions = jsonencode([
    {
      name  = "fastapi-service"
      image = "${aws_ecr_repository.ElasticContainerRegistry.repository_url}:latest" # Using the latest image from ECR

      # Environment variables
      environment = [
        {
          name  = "OPENWEATHERMAP_API_KEY"
          value = "bd5e378503939ddaee76f12ad7a97608"
        },
      ]
      # Port mappings for your application (adjust based on your app's configuration)
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
          protocol      = "tcp"
          appProtocol   = "http"
        },
        {
          containerPort = 8000 # Port your application listens to inside the container
          hostPort      = 8000
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

      # Log configuration using AWS CloudWatch Logs
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/fastapi-service"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
          awslogs-create-group  = "true"
          mode                  = "non-blocking"
        }
      }

      essential = true # Ensure the container is marked as essential
    }
  ])
}

###################################################
#           ECS Service inside Cluster            #
###################################################

resource "aws_ecs_service" "fastapi_ecs_service" {
  name            = "fastapi-service"
  cluster         = aws_ecs_cluster.ECS_Cluster.id
  task_definition = aws_ecs_task_definition.fargate_task.arn
  desired_count   = 1

  # Capacity Provider Strategy: Prefer Fargate Spot, fallback to Fargate
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100 # Primary preference for Fargate Spot 
    base              = 0
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1 # Secondary fallback to Fargate if Fargate Spot is unavailable
    base              = 0 # Ensures that Fargate is used if Fargate Spot fails
  }

  network_configuration {
    subnets          = [data.aws_subnet.selected_subnet.id]
    security_groups  = [aws_security_group.ecs_web_access_sg.id] # Apply the custom SG
    assign_public_ip = true
  }

  tags = merge(local.common_tags,
    {
      Name = upper("fastapi-ecs-service")
    }
  )
}
