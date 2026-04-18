output "instance_name" {
  description = "Compute Instance Name"
  value       = google_compute_instance.app.name
}

output "instance_self_link" {
  description = "Compute Instance Self Link"
  value       = google_compute_instance.app.self_link
}

output "service_account_email" {
  description = "Compute Service Account Email"
  value       = google_service_account.compute.email
}
