variable "environment" {
  description = "Name of the environment the module belongs too."
  type        = string
}

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

variable "ecs_task_definition_name" {
  description = "ECS task definition name for a single or group of containers."
  type        = string
}

variable "ecs_task_network_mode" {
  description = "ECS task container network mode."
  type        = string
  default     = "awsvpc"
}

variable "vpc_id" {
  description = "VPC identifier."
  type        = string
}

variable "ecs_container_name" {
  description = "ECS container name."
  type        = string
}

variable "ecs_container_image" {
  description = "ECS container image to pull."
  type        = string
}

variable "ecs_container_cpu_limit" {
  description = "ECS container cpu usage limit."
  type        = string
}

variable "ecs_container_mem_limit" {
  description = "ECS container memory usage limit."
  type        = string
}

variable "ecs_container_inside_port" {
  description = "ECS container inside port."
  type        = string
}

variable "ecs_container_outside_port" {
  description = "ECS container outside port to map on host."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ESB deployment."
  type        = list
}
