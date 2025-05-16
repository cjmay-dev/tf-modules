variable "APP_SHORTNAME" {
    description = "Subdomain where the app is hosted"
    type        = string
}

variable "ENV_SLUG" {
    description = "Environment slug"
    type        = string
}

variable "CLOUDFLARE_DOMAIN" {
    description = "Root domain where the app is hosted"
    type        = string
}

variable "CLOUDFLARE_API_TOKEN" {
    description = "API token with 'Account.Cloudflare Tunnel' and 'Zone.DNS' permissions"
    type        = string
    sensitive   = true
}

variable "CLOUDFLARE_ACCOUNT_ID" {
    description = "Cloudflare Account ID"
    type        = string
}

variable "CLOUDFLARE_ZONE_ID" {
    description = "Cloudflare Zone ID"
    type        = string
}