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

  encryption {
    default_kms_key_name = null
  }

  public_access_prevention = "enforced"
}
