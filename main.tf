provider "google" {
  credentials = file("/home/altron/jotform-interns-gcp.json")
  project     = var.project_id
  region      = var.region
}
