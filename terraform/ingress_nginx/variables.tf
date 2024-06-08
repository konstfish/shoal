variable "external_ip" {
  description = "The external IP address for the Ingress Controller."
  type        = string
}

variable "cloudflare_api_token" {
  description = "The API Token for Cloudflare."
  type        = string
  sensitive   = true
}

variable "use_proxy_protocol" {
  description = "Whether to use the PROXY protocol for the Ingress Controller."
  type        = bool
  default     = false
}