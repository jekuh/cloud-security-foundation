terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "tfstate" {
  name          = var.state_bucket_name
  location      = var.region
  force_destroy = false

  versioning {
    enabled = true
  }


  public_access_prevention = "enforced"
}
