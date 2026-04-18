output "vpc_id" {
  description = "VPC ID"
  value       = google_compute_network.vpc.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = google_compute_subnetwork.public.id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = google_compute_subnetwork.private.id
}

output "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  value       = [google_compute_subnetwork.public.id]
}

output "private_subnet_ids" {
  description = "List of Private Subnet IDs"
  value       = [google_compute_subnetwork.private.id]
}
