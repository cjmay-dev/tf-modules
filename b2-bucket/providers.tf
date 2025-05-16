terraform {
  required_providers {
    b2 = {
      source = "Backblaze/b2"
      version = "0.10.0"
    }
  }
}

provider "b2" {
  application_key_id = var.B2_KEY_ID
  application_key    = var.B2_KEY_SECRET
}