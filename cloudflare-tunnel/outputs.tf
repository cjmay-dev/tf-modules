output "tunnel_token" {
    description = "Cloudflare Tunnel Token"
    value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.tunnel_token
    sensitive   = true
}