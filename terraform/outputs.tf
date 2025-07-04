output "servers_status" {
  value = {
    for server in hcloud_server.podman :
    server.name => server.status
  }
}

output "servers_ips" {
  value = {
    for server in hcloud_server.podman :
    server.name => server.ipv4_address
  }
}

output "load_balancer_ip" {
  value = var.instances > 1 ? hcloud_load_balancer.podman_lb[0].ipv4 : null
}

output "load_balancer_name" {
  value = var.instances > 1 ? hcloud_load_balancer.podman_lb[0].name : null
}

output "service_ip" {
  value = var.instances > 1 ? hcloud_load_balancer.podman_lb[0].ipv4 : hcloud_server.podman[0].ipv4_address
  description = "IP address used for the service (load balancer if multiple instances, first server if single instance)"
}
