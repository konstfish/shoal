# resource "kubernetes_secret" "hcloud_token" {
#   metadata {
#     name      = "cloudflare"
#     namespace = "external-dns"
#   }

#   data = {
#     "cloudflare_api_token" = var.cloudflare_api_token
#   }
# }