resource "helm_release" "rancher" {
  name             = "rancher"
  repository       = "https://releases.rancher.com/server-charts/latest"
  chart            = "rancher"
  namespace        = "cattle-system"
  version          = "2.9.2"
  create_namespace = true

  values = [
    file("${path.module}/helm/values.yml")
  ]
}
