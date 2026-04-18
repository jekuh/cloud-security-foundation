module "identity" {
  source      = "../../modules/identity"
  environment = var.environment
  name_prefix = var.name_prefix
  project_id  = var.project_id
}

module "project_services" {
  source     = "../../modules/project_services"
  project_id = var.project_id
}

module "storage" {
  source       = "../../modules/storage"
  environment  = var.environment
  name_prefix  = var.name_prefix
  project_id   = var.project_id
  kms_key_name = var.kms_key_name
}

module "monitoring" {
  source      = "../../modules/monitoring"
  environment = var.environment
  name_prefix = var.name_prefix
  project_id  = var.project_id

  depends_on = [module.project_services]
}

module "network" {
  source      = "../../modules/network"
  environment = var.environment
  name_prefix = var.name_prefix
  project_id  = var.project_id
  region      = var.region

  depends_on = [module.project_services]
}

module "compute" {
  source      = "../../modules/compute"
  environment = var.environment
  name_prefix = var.name_prefix
  project_id  = var.project_id
  region      = var.region
  vpc_id      = module.network.vpc_id
  subnet_id   = module.network.public_subnet_id

  depends_on = [module.project_services]
}

module "servers" {
  source      = "../../modules/servers"
  environment = var.environment
  name_prefix = var.name_prefix
  project_id  = var.project_id
  region      = var.region
  vpc_id      = module.network.vpc_id
  subnet_id   = module.network.public_subnet_id

  depends_on = [module.project_services]
}
