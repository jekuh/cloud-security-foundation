output "log_sink_name" {
  description = "Log Sink Name"
  value       = google_logging_project_sink.app.name
}

output "logs_bucket_name" {
  description = "Logs Bucket Name"
  value       = google_storage_bucket.logs.name
}
