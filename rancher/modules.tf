// core
module "cert_manager" {
  source = "../terraform/cert_manager"

  cloudflare_api_token = var.cloudflare_api_token
}

module "rancher" {
  source = "../terraform/rancher"

  depends_on = [module.cert_manager]
}
resource "kubernetes_manifest" "fleet_projects" {
  manifest = yamldecode(file("${path.module}/kubernetes/fleet-local.yaml"))

  depends_on = [module.rancher]
}