variable "environment" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "project_id" {
  type = string
}

resource "google_logging_project_sink" "app" {
  name        = "${var.name_prefix}-${var.environment}-log-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.logs.name}"
  filter      = "resource.type=gce_instance"

  unique_writer_identity = true
}

resource "google_storage_bucket" "logs" {
  name          = "${var.name_prefix}-${var.environment}-logs-bucket"
  location      = "US"
  project       = var.project_id
  force_destroy = false

  versioning {
    enabled = true
  }

  public_access_prevention = "enforced"
}

resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/storage.objectCreator"
  member  = google_logging_project_sink.app.writer_identity
}
