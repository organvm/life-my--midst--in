# Terraform root module placeholder for interactive CV infrastructure.

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default     = "placeholder-project-id"
}

variable "region" {
  type        = string
  description = "The GCP region"
  default     = "us-central1"
}
