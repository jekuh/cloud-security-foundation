output "app_role_name" { value = module.identity.app_role_name }
output "app_bucket_name" { value = module.storage.app_bucket_name }
output "log_group_name" { value = module.monitoring.app_log_group_name }
output "vpc_id" { value = module.network.vpc_id }

