terraform {
  required_providers {
    infisical = {
      source  = "infisical/infisical"
      version = "0.15.10"
    }
  }
}

provider "infisical" {
  auth = {
    oidc = {}
  }
}