terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.77.1"
    }
  }
}

provider "proxmox" {
  ### needs the following environment variables:
  # PROXMOX_VE_ENDPOINT
  # PROXMOX_VE_API_TOKEN
  # PROXMOX_VE_INSECURE  # self-signed TLS cert in use
  ssh {
    agent = true
    username = "root"
  }
}