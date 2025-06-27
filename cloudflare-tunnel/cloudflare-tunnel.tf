locals {
  subdomain = var.ENV_SLUG == "prod" ? var.APP_SHORTNAME : "${var.APP_SHORTNAME}-${var.ENV_SLUG}"
}

resource "random_password" "tunnel_secret" {
    length = 64
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
    # requires Account.Cloudflare-Tunnel Edit permission
    account_id    = var.CLOUDFLARE_ACCOUNT_ID
    name          = "${local.subdomain}.${var.CLOUDFLARE_DOMAIN}"
    secret = base64sha256(random_password.tunnel_secret.result)
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "tunnel_config" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  tunnel_id = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
  config {
    ingress_rule {
      hostname = "${var.APP_SHORTNAME}.${var.CLOUDFLARE_DOMAIN}"
      service = "http://traefik:80"
    }
    ingress_rule{
      service  = "http_status:404"
    }
  }
}

resource "cloudflare_record" "tunnel_dns" {
    # requires ZONE.DNS Edit permission
    zone_id = var.CLOUDFLARE_ZONE_ID
    name    = local.subdomain
    content = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
    type    = "CNAME"
    ttl     = 1
    proxied = true
}