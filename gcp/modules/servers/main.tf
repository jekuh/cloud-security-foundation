variable "environment" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

resource "google_compute_instance" "server" {
  name         = "${var.name_prefix}-${var.environment}-server"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_id

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = google_service_account.server.email
    scopes = ["cloud-platform"]
  }
}

resource "google_service_account" "server" {
  account_id   = "${var.name_prefix}-${var.environment}-server-sa"
  display_name = "${var.name_prefix} ${var.environment} Server Service Account"
  project      = var.project_id
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.name_prefix}-${var.environment}-allow-ssh"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
