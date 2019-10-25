####
# ALB
####

resource "aws_lb" "this" {
  name               = format("esb-%s-application-lb", var.environment)
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["aws_security_group.this.id"]
  subnets            = var.subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "this" {
  name        = format("ecs-%s-application-tg", var.environment)
  port        = var.ecs_container_outside_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.ecs_container_outside_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_security_group" "this" {
  name   = format("%s-alb-sg", var.ecs_cluster_name)
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "this_ingress_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}

####
# ECS Fargate
####

resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_service" "this" {
  name    = var.ecs_service_name
  cluster = aws_ecs_cluster.this.id

  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.ecs_task_count

  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  platform_version    = var.ecs_service_platform_version

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.ecs_container_name
    container_port   = var.ecs_container_outside_port
  }

  depends_on = [
    "aws_lb_listener.this",
  ]
}

data "template_file" "this" {
  template = "${file("${path.module}/task-definitions/service.json")}"

  vars = {
    container_name         = var.ecs_container_name
    container_image        = var.ecs_container_image
    container_cpu_limit    = var.ecs_container_cpu_limit
    container_mem_limit    = var.ecs_container_mem_limit
    container_inside_port  = var.ecs_container_inside_port
    container_outside_port = var.ecs_container_outside_port
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.ecs_task_definition_name
  container_definitions    = data.template_file.this.rendered
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu_value
  memory                   = var.ecs_task_mem_value
  network_mode             = var.ecs_task_network_mode
}
