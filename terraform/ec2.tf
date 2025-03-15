

# Define a launch template to create EC2
resource "aws_launch_template" "main_ecs_launch_template" {
  name_prefix   = "main-ecs-template"
  image_id      = var.ec2_image_type
  instance_type = var.ec2_instance_type

  key_name               = var.main_key_pair
  vpc_security_group_ids = [aws_security_group.main_security_group.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.main_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  user_data = filebase64("${path.module}/ecs.sh")
}

# Define autoscaling group
resource "aws_autoscaling_group" "main_esc_asg" {
  vpc_zone_identifier = [aws_subnet.main_subnet_a.id, aws_subnet.main_subnet_b.id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = aws_launch_template.main_ecs_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

# Define the application load balancer
resource "aws_lb" "main_ecs_alb" {
  name               = "main-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main_security_group.id]
  subnets            = [aws_subnet.main_subnet_a.id, aws_subnet.main_subnet_b.id]

  tags = {
    Name = "main-ecs-alb"
  }
}

# Define the application alb listener that routes client requests to target group
resource "aws_lb_listener" "main_ecs_alb_listener" {
  load_balancer_arn = aws_lb.main_ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_ecs_tg.arn
  }
}

# Define the application ecs target group
resource "aws_lb_target_group" "main_ecs_tg" {
  name        = "main-ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main_vpc.id

  health_check {
    path = "/"
  }
}
