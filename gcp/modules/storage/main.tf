variable "environment" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "project_id" {
  type = string
}

resource "google_storage_bucket" "app" {
  name          = "${var.name_prefix}-${var.environment}-app-bucket"
  location      = "US"
  project       = var.project_id
  force_destroy = false

  versioning {
    enabled = true
  }

  dynamic "encryption" {
    for_each = var.kms_key_name == null ? [] : [var.kms_key_name]

    content {
      default_kms_key_name = encryption.value
    }
  }

  public_access_prevention = "enforced"
}
