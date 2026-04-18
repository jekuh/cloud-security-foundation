variable "environment" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "project_id" {
  type = string
}

resource "google_service_account" "app" {
  account_id   = "${var.name_prefix}-${var.environment}-app-sa"
  display_name = "${var.name_prefix} ${var.environment} App Service Account"
  project      = var.project_id
}
