data "cloudflare_zone" "dns_zone" {
  account_id = var.cloudflare_account_id
  name       = var.domain_name
}

resource "cloudflare_record" "podman_server" {
  for_each = {
    for server in hcloud_server.podman :
    server.name => server.ipv4_address
  }
  zone_id = data.cloudflare_zone.dns_zone.id
  name    = each.key
  content = each.value
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "service" {
  zone_id = data.cloudflare_zone.dns_zone.id
  name    = var.service_name
  content = var.instances > 1 ? hcloud_load_balancer.podman_lb[0].ipv4 : hcloud_server.podman[0].ipv4_address
  type    = "A"
  ttl     = 3600
}
