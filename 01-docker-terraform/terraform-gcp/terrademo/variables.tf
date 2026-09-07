variable "project" {
  description = "Project"
  default     = "dtc-de-course-507510"
}

variable "location" {
  description = "Project Location"
  default     = "EU"
}

variable "region" {
  description = "Region"
  default     = "europe-west2"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "${var.project}-terrabucket"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "demo_dataset"
}
