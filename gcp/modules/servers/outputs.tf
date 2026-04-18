output "instance_name" {
  description = "Server Instance Name"
  value       = google_compute_instance.server.name
}

output "instance_self_link" {
  description = "Server Instance Self Link"
  value       = google_compute_instance.server.self_link
}

output "service_account_email" {
  description = "Server Service Account Email"
  value       = google_service_account.server.email
}
