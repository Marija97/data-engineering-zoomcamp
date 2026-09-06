terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.1.0"
    }
  }
}

provider "google" {
  project = "dtc-de-course-507510"
  region  = "europe-west2"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "dtc-de-course-507510-terrabucket"
  location      = "EU"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}