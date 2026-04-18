module "identity" {
  source      = "../../modules/identity"
  environment = var.environment
  name_prefix = var.name_prefix
  project_id  = var.project_id
}

module "storage" {
  source      = "../../modules/storage"
  environment = var.environment
  name_prefix = var.name_prefix
  project_id  = var.project_id
}

module "monitoring" {
  source      = "../../modules/monitoring"
  environment = var.environment
  name_prefix = var.name_prefix
  project_id  = var.project_id
}

module "network" {
  source      = "../../modules/network"
  environment = var.environment
  name_prefix = var.name_prefix
  project_id  = var.project_id
  region      = var.region
}

module "compute" {
  source      = "../../modules/compute"
  environment = var.environment
  name_prefix = var.name_prefix
  project_id  = var.project_id
  region      = var.region
  vpc_id      = module.network.vpc_id
  subnet_id   = module.network.public_subnet_id
}

module "servers" {
  source      = "../../modules/servers"
  environment = var.environment
  name_prefix = var.name_prefix
  project_id  = var.project_id
  region      = var.region
  vpc_id      = module.network.vpc_id
  subnet_id   = module.network.public_subnet_id
}
