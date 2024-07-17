resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  version          = "v4.10.1"
  create_namespace = true

  values = [
    file("${path.module}/helm/values.yaml"),
  ]

  /*set {
    name  = "controller.service.externalIPs[0]"
    value = var.external_ip
  }*/

  // https://github.com/kubernetes/kubernetes/issues/66607
  // this is killing me tbh, super ugly config but this works for external-dns for now
  // will have to find something else at some point

  set {
    name = "controller.service.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = var.cluster_domain
  }

  set {
    name = "controller.service.annotations.external-dns\\.alpha\\.kubernetes\\.io/target"
    value = var.external_ip
  }

  set {
    name = "controller.config.use-proxy-protocol"
    value = var.use_proxy_protocol
  }

  set {
    name = "controller.config.compute-full-forwarded-for"
    value = var.use_proxy_protocol
  }

  set {
    name = "controller.config.use-forwarded-headers"
    value = var.use_proxy_protocol
  }
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  namespace        = "external-dns"
  version =  "8.0.2"
  create_namespace = true

  values = [
    file("${path.module}/helm/external-dns-values.yaml"),
  ]

  set {
    name  = "txtPrefix"
    value = "extdns"
  }

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
