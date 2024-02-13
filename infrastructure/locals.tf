locals {
  bucket_name = "notes-taker-terraform-state-test-bucket"
  table_name  = "terraform-locks-table"

  ecr_repository_name = "test_app_ecr_repository"

  test_app_ecs_cluster_name = "test-app-ecs-cluster"
  availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]

  test_app_task_family = "test-app-task-family"

  test_app_container_name   = "test-app-container-name"
  test_app_container_port   = 3000
  test_app_container_memory = 512
  test_app_container_cpu    = 256

  ecs_task_execution_role_name       = "test-app-ecs-task-execution-role"
  test_app_alb_name                  = "test-app-alb"
  test_app_alb_target_group_name     = "test-app-alb-target-group"
  test_app_ecs_service_name          = "test-app-ecs-service"
  test_app_ecs_service_desired_count = 1

  log_group_name = "/ecs/test-app-ecs-cluster"
}
