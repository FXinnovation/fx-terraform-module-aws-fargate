####
# ALB
####






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
  platform_version    = var.ecs_service_platform_version
  scheduling_strategy = "REPLICA"

  iam_role   = aws_iam_role.this.arn
  depends_on = ["aws_iam_role_policy.this"]

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.ecs_container_name
    container_port   = var.ecs_container_port
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.ecs_tasks_definition_name
  container_definitions    = "${file("task-definitions/service.json")}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
}



####
# IAM Policies
####
