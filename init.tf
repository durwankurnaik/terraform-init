terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }

  # Configure the GCS remote backend
  backend "gcs" {
    bucket = "terraform-state-handler-poc"
    prefix = "dev/state" # Optional: organize by environment/project
  }
}

provider "google" {
  project = var.project_id
  region  = var.default_region
  zone    = var.default_zone
}
