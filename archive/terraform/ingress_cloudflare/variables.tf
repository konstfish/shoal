// variables
// create with permissions specified in https://github.com/STRRL/cloudflare-tunnel-ingress-controller
variable "cloudflare_api_token" {
  description = "The API Token for Cloudflare."
  type        = string
  sensitive   = true
}

variable "cloudflare_acount_id" {
  description = "The Cloudflare Account ID."
  type        = string
}

variable "cloudflare_tunnel_name" {
  description = "The name for the Cloudflare Tunnel (will be created by helm chart)."
  type        = string
  default     = "tetra"
}
