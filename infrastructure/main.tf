terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket         = "notes-taker-terraform-state-test-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-table"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

module "tf-state" {
  source      = "./modules/tf-state"
  bucket_name = local.bucket_name
  table_name  = local.table_name
}

module "ecr" {
  source              = "./modules/ecr"
  ecr_repository_name = local.ecr_repository_name
}



module "ecs" {
  source = "./modules/ecs"

  test_app_ecs_cluster_name = local.test_app_ecs_cluster_name
  availability_zones        = local.availability_zones

  test_app_task_family         = local.test_app_task_family
  ecr_repository_url           = module.ecr.ecr_repository_url
  test_app_container_port      = local.test_app_container_port
  test_app_container_name      = local.test_app_container_name
  ecs_task_execution_role_name = local.ecs_task_execution_role_name

  test_app_alb_name              = local.test_app_alb_name
  test_app_alb_target_group_name = local.test_app_alb_target_group_name
  test_app_ecs_service_name      = local.test_app_ecs_service_name


  test_app_container_memory          = local.test_app_container_memory
  test_app_container_cpu             = local.test_app_container_cpu
  test_app_ecs_service_desired_count = local.test_app_ecs_service_desired_count
}

module "cloud-watch" {
  source = "./modules/cloud-watch"

  log_group_name = local.log_group_name

}
