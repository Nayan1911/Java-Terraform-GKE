variable "credentials_file" {
  description = "Path to the service account JSON key file"
  type        = string
  default     = "path/to/your/credentials.json"
}

variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
  default     = "glowing-palace-414116"
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Google Cloud zone"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "cluster-1"
}
