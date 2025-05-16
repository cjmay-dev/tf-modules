terraform {
    required_providers {
        cloudflare = {
        source  = "cloudflare/cloudflare"
        version = "4.52.0"
    }
    random = {
        source  = "hashicorp/random"
        version = "3.7.2"
    }
  }
}

provider "cloudflare" {
    api_token = var.CLOUDFLARE_API_TOKEN
}