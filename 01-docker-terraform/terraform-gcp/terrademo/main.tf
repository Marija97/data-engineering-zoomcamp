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

resource "google_bigquery_dataset" "demo-dataset" {
  dataset_id    = "demo_dataset"
  friendly_name = "Demo Dataset"
  description   = "This is a dataset for practicing Terraform"
  location      = "EU"
}