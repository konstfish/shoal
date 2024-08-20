// core
module "cert_manager" {
  source = "../terraform/cert_manager"

  cloudflare_api_token = var.cloudflare_api_token
}