// core
module "cert_manager" {
  source = "../terraform/cert_manager"

  cloudflare_api_token = var.cloudflare_api_token

  depends_on = [ helm_release.ccm ]
}

module "rancher" {
  source = "../terraform/rancher"

  depends_on = [module.cert_manager]
}