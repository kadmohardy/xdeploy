# Create ECR for xdeploy images
resource "aws_ecr_repository" "ecr" {
  name                 = "xdeploy"
  image_tag_mutability = var.image_mutability
  encryption_configuration {
    encryption_type = var.encrypt_type
  }
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}

# Create ECS cluster 
resource "aws_ecs_cluster" "main_ecs_cluster" {
  name = "main-ecs-cluster"
}

resource "aws_ecs_capacity_provider" "main_ecs_capacity_provider" {
  name = "main_ecs_capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.main_esc_asg.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 3
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "main_ecs_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.main_ecs_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.main_ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.main_ecs_capacity_provider.name
  }
}

# Define the ECS task definition for the service
resource "aws_ecs_task_definition" "main_ecs_task_definition" {
  family             = "main-ecs-task"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::684644783255:role/ecsTaskExecutionRole"
  cpu                = 256
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "dockergs"
      image     = aws_ecr_repository.ecr.repository_url
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 4000
          hostPort      = 4000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# Define the ECS service that will run the task
resource "aws_ecs_service" "main_ecs_service" {
  name            = "main-ecs-service"
  cluster         = aws_ecs_cluster.main_ecs_cluster.arn
  task_definition = aws_ecs_task_definition.main_ecs_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.main_subnet_a.id, aws_subnet.main_subnet_b.id]
    security_groups = [aws_security_group.main_security_group.id]
  }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main_ecs_capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main_ecs_tg.arn
    container_name   = "dockergs"
    container_port   = 80
  }

  depends_on = [aws_autoscaling_group.main_esc_asg]
}
