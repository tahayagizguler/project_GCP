resource "google_compute_network" "vpc_network" {
  name                    = "project-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "app_server_subnet" {
  name          = "app-server-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_subnetwork" "mysql_server_subnet" {
  name          = "mysql-server-subnet"
  ip_cidr_range = "10.0.2.0/24"
  network       = google_compute_network.vpc_network.self_link
}

# Firewall Rules
resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["80", "22","3306"]
  }
  source_ranges = ["0.0.0.0/0"]
  #target_service_accounts = provider.credentials
}


resource "google_compute_network" "vpc_network_cicd" {
  name                    = "cicd-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "server_subnet" {
  name          = "server-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc_network_cicd.self_link
}

# Firewall Rules
resource "google_compute_firewall" "allow-http-2" {
  name    = "allow-http-2"
  network = google_compute_network.vpc_network_cicd.id
  allow {
    protocol = "tcp"
    ports    = ["80", "22","8080"]
  }
  source_ranges = ["0.0.0.0/0"]
}
