resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = var.APP_SHORTNAME
  tags      = ["terraform", "docker"]
  node_name = "pve"
  agent {
    enabled = true
  }
  cpu {
    cores = var.CPU_CORES
    type  = "host"
  }
  memory {
    dedicated = var.MEMORY
    floating  = var.MEMORY
  }
  disk {
    datastore_id = var.DATASTORE_ID
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "scsi0"
    size         = var.DISK_SIZE
    discard      = "on"
    ssd          = true
  }
  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }
  network_device {
    bridge = var.NETWORK_BRIDGE
  }
  operating_system {
    type = "l26"  # Linux 2.6 - 6.x
  }
  tpm_state {
    datastore_id = var.DATASTORE_ID
    version = "v2.0"
  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  overwrite    = true
  overwrite_unmanaged = true
}