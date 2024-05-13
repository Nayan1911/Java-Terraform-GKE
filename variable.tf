variable "credentials_file" {
  description = "credentials"
  type        = string
  default     = "D:/STUDY/DEVOPS/DevOps - Docker, Kubernetes, Terraform and Azure DevOps/PRACTISE\GKE/glowing-palace-414116-d0fd4835216e.json"
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
  default     = "us-central1-c"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "cluster-1"
}
