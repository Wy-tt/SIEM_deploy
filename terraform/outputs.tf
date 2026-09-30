output "container_ip" {
  value = proxmox_virtual_environment_container.debian_local.ipv4["eth0"]
}