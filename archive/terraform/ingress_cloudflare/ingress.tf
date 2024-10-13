resource "helm_release" "cloudflare_tunnel_ingress_controller" {
  name             = "cloudflare-tunnel-ingress-controller"
  repository       = "https://helm.strrl.dev"
  chart            = "cloudflare-tunnel-ingress-controller"
  namespace        = "cloudflare-tunnel-ingress-controller"
  create_namespace = true

  set {
    name  = "cloudflare.apiToken"
    value = var.cloudflare_api_token
  }

  set {
    name  = "cloudflare.accountId"
    value = var.cloudflare_acount_id
  }

  set {
    name  = "cloudflare.tunnelName"
    value = var.cloudflare_tunnel_name
  }

  timeout = 100
}