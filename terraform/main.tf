provider "proxmox" {
  endpoint  = var.pve_host
  api_token = var.terraform_api_key
  #Lab only workaround for self-signed certs, remove in production
  insecure = true
}

resource "proxmox_virtual_environment_container" "debian_local" {
  description  = "Built by terraform"
  node_name    = "pve"
  vm_id        = 302
  unprivileged = true
  features {
    nesting = true
  }

  memory {
    dedicated = 7168
    swap      = 0
  }

  cpu {
    architecture = "amd64"
    cores        = 4
  }

  initialization {
    hostname = "WazuhCT"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      password = var.terraform_build_pass
    }
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = "HDD1:vztmpl/debian-13-standard_13.6-1_amd64.tar.zst"
    type             = "debian"
  }

  disk {
    datastore_id = "HDD1"
    size         = 120
  }
}