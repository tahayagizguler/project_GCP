variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "devops-interns" # jotforminternproject  
}

variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "ansible"
}

variable "private_key_path" {
  description = "Path to the private SSH key file"
  type        = string
  default     = "~/.ssh/ansible_ed25519"
}

variable "region" {
  description = "Google Cloud region for the resources"
  default     = "europe-central2"
}

variable "zone" {
  description = "Google Cloud zone for the resources"
  default     = "europe-central2-a"
}


variable "machine_type" {
  description = "Google Cloud machine type for the instances"
  default     = "e2-micro"
}

variable "image" {
  description = "Google Cloud image for the instances"
  default     = "debian-cloud/debian-11"
}

variable "VAULT_PASS" {
  type    = string
}
