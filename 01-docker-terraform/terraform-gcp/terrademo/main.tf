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