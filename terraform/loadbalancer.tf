# Hetzner Cloud Load Balancer - only created when instances > 1
resource "hcloud_load_balancer" "podman_lb" {
  count              = var.instances > 1 ? 1 : 0
  name               = "${var.service_name}-lb"
  load_balancer_type = "lb11"
  location           = var.location
  labels = {
    type = "podman-loadbalancer"
  }
}

# Load balancer target - all podman servers (only when LB exists)
resource "hcloud_load_balancer_target" "podman_targets" {
  for_each         = var.instances > 1 ? { for i, server in hcloud_server.podman : server.name => server } : {}
  type             = "server"
  load_balancer_id = hcloud_load_balancer.podman_lb[0].id
  server_id        = each.value.id
}

# HTTP service on port 80 (only when LB exists)
resource "hcloud_load_balancer_service" "http_service" {
  count            = var.instances > 1 ? 1 : 0
  load_balancer_id = hcloud_load_balancer.podman_lb[0].id
  protocol         = "http"
  listen_port      = 80
  destination_port = 80
  
  health_check {
    protocol = "http"
    port     = 80
    interval = 15
    timeout  = 10
    retries  = 3
    http {
      path = "/"
      status_codes = ["2??", "3??"]
    }
  }
}

# HTTPS service on port 443 (only when LB exists)
resource "hcloud_load_balancer_service" "https_service" {
  count            = var.instances > 1 ? 1 : 0
  load_balancer_id = hcloud_load_balancer.podman_lb[0].id
  protocol         = "https"
  listen_port      = 443
  destination_port = 80
  
  health_check {
    protocol = "http"
    port     = 80
    interval = 15
    timeout  = 10
    retries  = 3
    http {
      path = "/"
      status_codes = ["2??", "3??"]
    }
  }
} 