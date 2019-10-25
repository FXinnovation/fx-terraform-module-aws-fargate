variable "ecs_cluster_name" {
  description = "ECS cluster name."
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name."
  type        = string
}

variable "ecs_task_count" {
  description = "Number of task replicas to spawn."
  type        = string
}

variable "ecs_service_platform_version" {
  description = "ECS platform version for container engine."
  type        = string
  default     = "LATEST"
}

variable "ecs_container_name" {
  description = "ECS task related container name."
  type        = string
}

variable "ecs_container_port" {
  description = "ECS container side port to map."
  type        = string
}

variable "ecs_tasks_definition_name" {
  description = "ECS task definition name for a single or group of containers."
  type        = string
}
