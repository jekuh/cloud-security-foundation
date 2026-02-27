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

module "compute" {
  source      = "../../modules/compute"
  environment = var.environment
  name_prefix = var.name_prefix
}