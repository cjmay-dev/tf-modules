resource "proxmox_virtual_environment_vm" "data_vm" {
  lifecycle {
    prevent_destroy = true
  }
  node_name = var.NODE_NAME
  started = false
  on_boot = false

  disk {
    datastore_id = var.DATASTORE_ID
    interface    = "scsi0"
    size         = var.DISK_SIZE
    discard      = "on"
    ssd          = true
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  lifecycle {
    create_before_destroy = true
  }
  name      = var.APP_SHORTNAME
  tags      = ["terraform", "docker"]
  node_name = var.NODE_NAME
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
    size         = 32
    discard      = "on"
    ssd          = true
  }
  dynamic "disk" {
    for_each = { for idx, val in proxmox_virtual_environment_vm.data_vm.disk : idx => val }
    iterator = data_disk
    content {
      datastore_id      = data_disk.value["datastore_id"]
      path_in_datastore = data_disk.value["path_in_datastore"]
      file_format       = data_disk.value["file_format"]
      size              = data_disk.value["size"]
      # assign from scsi2 and up
      interface         = "scsi${data_disk.key + 2}"
    }
  }
  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
    meta_data_file_id = proxmox_virtual_environment_file.meta_data_cloud_config.id
  }
  network_device {
    bridge = var.NETWORK_BRIDGE
  }
  serial_device {
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