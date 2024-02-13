variable "test_app_ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "availability_zones" {
  description = "The availability zones in which to create the ECS cluster"
  type        = list(string)
}

variable "test_app_task_family" {
  description = "The family of the ECS task"
  type        = string
}

variable "test_app_container_name" {
  description = "The name of the ECS container"
  type        = string
}

variable "test_app_container_port" {
  description = "The port of the ECS container"
  type        = number
}

variable "test_app_container_memory" {
  description = "The memory of the ECS container"
  type        = number
}

variable "test_app_container_cpu" {
  description = "The cpu of the ECS container"
  type        = number
}

variable "ecr_repository_url" {
  description = "The URL of the ECR repository"
  type        = string
}

variable "ecs_task_execution_role_name" {
  description = "The name of the ECS task execution role"
  type        = string
}

variable "test_app_alb_name" {
  description = "The name of the ECS task execution role"
  type        = string
}

variable "test_app_alb_target_group_name" {
  description = "The name of the Load Balancer target group"
  type        = string
}

variable "test_app_ecs_service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "test_app_ecs_service_desired_count" {
  description = "The desired count of the ECS service"
  type        = number
}
