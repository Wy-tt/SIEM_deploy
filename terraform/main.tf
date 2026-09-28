provider "proxmox" {
    pm_api_url      = var.pve_host
    pm_api_token_id = var.terraform_user
    pm_api_token    = var.terraform_token
    pm_debug        = true
    pm_log_enable   = true
    pm_log_file     = "terraform_proxmox.log"
    pm_log_levels = {
        _default    = "debug"
        _capturelog = ""
    }
}

resource "proxmox_lxc" "basic" {
    target_node     = "pve"
    host_name       = "WazuhCT"
    ostemplate      = "HDD1:vztmpl/debian-13-standard_13.6-1_and64.tar.zst"
    password        = var.terraform_build_pass
    unprivileged    = true
    memory          = 7168
    cores           = 4

    rootfs {
        storage = "HDD1"
        size    = "120G"
    }

    network {
        name    = "eth0"
        bridge  = "vmbr0"
        ip      = "dhcp"
    }
}