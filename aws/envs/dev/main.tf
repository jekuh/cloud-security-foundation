module "identity" {
  source      = "../../modules/identity"
  environment = var.environment
  name_prefix = var.name_prefix
}

module "storage" {
  source      = "../../modules/storage"
  environment = var.environment
  name_prefix = var.name_prefix
}

module "monitoring" {
  source      = "../../modules/monitoring"
  environment = var.environment
  name_prefix = var.name_prefix
}

module "network" {
  source      = "../../modules/network"
  environment = var.environment
  name_prefix = var.name_prefix
}

module "servers" {
  source             = "../../modules/servers"
  environment        = var.environment
  name_prefix        = var.name_prefix
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
}
