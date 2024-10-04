// kuberneste manifest cert-manager.yaml

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.16.0"

  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubernetes_secret" "cloudflare_api_token_secret" {
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = helm_release.cert_manager.namespace
  }

  type = "Opaque"

  data = {
    "api-token" = var.cloudflare_api_token
  }

  depends_on = [helm_release.cert_manager]
}

resource "helm_release" "cert_manager_issuers" {
  name       = "cert-manager-issuers"
  repository = "https://dysnix.github.io/charts"
  chart      = "raw"

  values = [
    file("${path.module}/helm/issuers/values.yml")
  ]

  depends_on = [ helm_release.cert_manager ]
}
