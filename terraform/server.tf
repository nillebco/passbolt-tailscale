resource "hcloud_server" "podman" {
  count       = var.instances
  name        = "${var.service_name}-${count.index}"
  image       = var.os_type
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
  labels = {
    type = "podman-server"
  }
  user_data = templatefile("user_data.yml", {
    # terraform read the content of the file at the path specified as a variable
    SSH_KEY_CONTENT = file(var.ssh_key_path)
  })
}
