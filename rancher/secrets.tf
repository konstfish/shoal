
resource "kubernetes_secret" "hcloud_token" {
  metadata {
    name      = "hcloud"
    namespace = "kube-system"
  }

  data = {
    "token" = var.hcloud_token
  }
}