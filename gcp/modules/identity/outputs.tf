output "service_account_email" {
  description = "Service Account Email"
  value       = google_service_account.app.email
}

output "service_account_id" {
  description = "Service Account ID"
  value       = google_service_account.app.id
}
