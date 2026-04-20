module "network" {
  aws_region   = var.aws_region
  source       = "../modules/network"
  project_name = var.project_name
  vpc_cidr     = "10.0.0.0/16"
}

module "api_gateway" {
  source                     = "../modules/api_gateway"
  project_name               = var.project_name
  vpc_id                     = module.network.vpc_id
  private_subnets            = module.network.private_subnets
  vpc_link_sg_id             = module.network.vpc_link_sg_id
  load_balancer_listener_arn = module.app_container.load_balancer_listener_arn
}

module "app_container" {
  source          = "../modules/app_container"
  aws_region      = var.aws_region
  project_name    = var.project_name
  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  table_name      = module.storage.table_name
  table_arn       = module.storage.table_arn
  container_image = var.container_image
  container_port  = 3000
  log_group_name  = module.logging.log_group_name
}

module "database" {
  source       = "../modules/database"
  project_name = var.project_name
}

module "logging" {
  source            = "../modules/logging"
  log_group_name    = "/ecs/${var.project_name}"
  retention_in_days = 14
}

module "gitlab_iam" {
  source              = "./modules/iam_gitlab_role"
  project_name        = var.project_name
  gitlab_project_path = "your-username/your-repo-name"
  gitlab_branch       = "main"
}

output "gitlab_ci_role_arn" {
  value = module.gitlab_iam.role_arn
}
