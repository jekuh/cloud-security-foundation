output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "subnet_id" {
  description = "Public Subnet ID"
  value       = module.network.public_subnet_id
}

output "storage_bucket_name" {
  description = "Storage Bucket Name"
  value       = module.storage.bucket_name
}

output "service_account_email" {
  description = "Service Account Email"
  value       = module.identity.service_account_email
}

output "log_sink_name" {
  description = "Log Sink Name"
  value       = module.monitoring.log_sink_name
}

output "instance_name" {
  description = "Compute Instance Name"
  value       = module.compute.instance_name
}
