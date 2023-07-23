provider "google" {
  credentials = file("/home/altron/newkey-jotforminternproject.json")
  project     = var.project_id
  region      = var.region
}
