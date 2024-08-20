// core
module "cert_manager" {
  source = "../terraform/cert_manager"

  cloudflare_api_token = var.cloudflare_api_token
}

module "rancher" {
  source = "../terraform/rancher"

  depends_on = [module.cert_manager]
}

module "gitops" {
  source = "../terraform/gitops"

  depends_on = [module.rancher]
}