
resource "kubernetes_secret" "hcloud_token" {
  metadata {
    name      = "hcloud"
    namespace = "kube-system"
  }

  data = {
    "token" = var.hcloud_token
    "network" = "vcn-kf-htz-barracuda"
  }
}

resource "helm_release" "ccm" {
  name       = "hcloud-cloud-controller-manager"
  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-cloud-controller-manager"
  version    = "1.23.0"

  namespace = "kube-system"

  set {
    name = "networking.enabled"
    value = true
  }

  set {
    name = "networking.clusterCIDR"
    value = "10.44.0.0/16"
  }

  depends_on = [kubernetes_secret.hcloud_token]
}