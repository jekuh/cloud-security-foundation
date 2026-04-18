variable "project_id" {
  type = string
}

locals {
  services = toset([
    "compute.googleapis.com",
    "logging.googleapis.com",
  ])
}

resource "google_project_service" "required" {
  for_each = local.services

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}
