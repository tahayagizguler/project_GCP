
resource "google_compute_health_check" "healthcheck" { 
  name = "healthcheck"
  timeout_sec = 1
  check_interval_sec = 1
  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "backend_service" {
  name = "backend-service"
  port_name = "http"
  protocol = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck.self_link}"]
  backend {
    group = google_compute_instance_group.web_private_group.self_link
    balancing_mode = "RATE" # Giden istek sayısına göre trafik dağıtır.
    max_rate_per_instance = 100
  }
}


resource "google_compute_url_map" "url_map" {
  name = "load-balancer"
  default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_target_http_proxy" "target_http_proxy" {
  name = "proxy"
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name        = "global-forwarding-rule"
  target      = google_compute_target_http_proxy.target_http_proxy.self_link
  port_range  = "80"
}


output "load-balancer-ip-address" {
  value = google_compute_global_forwarding_rule.global_forwarding_rule.ip_address
}