resource "kubeneretes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_secret" "external_dns_cloudflare" {
  metadata {
    name      = "cloudflare"
    namespace = "external-dns"
  }

  data = {
    "cloudflare_api_token" = var.cloudflare_api_token
  }

  depends_on = [ kubeneretes_namespace.external_dns ]
}