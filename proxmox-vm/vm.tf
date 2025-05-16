resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = vars.APP_SHORTNAME
  tags      = ["terraform", "docker"]
  node_name = "pve"
  agent {
    enabled = true
  }
  cpu {
    cores = 2
    type  = "host"
  }
  memory {
    dedicated = 4096
    floating  = 4096
  }
  disk {
    datastore_id = var.DATASTORE_ID
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "scsi0"
    iothread     = true
    size         = 64
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
    bridge = "vmbr1"
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
  url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

output "vm_ipv4_address" {
  value = proxmox_virtual_environment_vm.ubuntu_vm.ipv4_addresses[1][0]
}