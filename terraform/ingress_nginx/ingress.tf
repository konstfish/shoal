resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  version          = "v4.10.1"
  create_namespace = true

  values = [
    file("${path.module}/helm/values.yml"),
  ]

  set {
    name  = "controller.service.externalIPs[0]"
    value = var.external_ip
  }

  set {
    name = "controller.config.use-proxy-protocol"
    value = var.use_proxy_protocol
  }
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true

  set {
    name  = "provider"
    value = "cloudflare"
  }

  set {
    name  = "cloudflare.apiToken"
    value = var.cloudflare_api_token
  }

  set {
    name  = "cloudflare.proxied"
    value = false
  }

  depends_on = [helm_release.ingress_nginx]
}
