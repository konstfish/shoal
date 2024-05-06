
// https://artifacthub.io/packages/helm/gatekeeper/gatekeeper

resource "helm_release" "kubewarden_crds" {
  name       = "kubewarden-crds"
  repository = "https://charts.kubewarden.io"
  chart      = "kubewarden-crds"
  version    = "1.5.0"

  values = [
    file("${path.module}/helm/values.yml")
  ]

  namespace        = "kubewarden"
  create_namespace = true
}

resource "helm_release" "kubewarden_controller" {
  name       = "kubewarden-controller"
  repository = "https://charts.kubewarden.io"
  chart      = "kubewarden-controller"
  version    = "2.0.11"

  values = [
    file("${path.module}/helm/values.yml")
  ]

  namespace        = "kubewarden"
  create_namespace = true

  depends_on = [ helm_release.kubewarden_crds ]
}

resource "helm_release" "kubewarden_defaults" {
  name       = "kubewarden-defaults"
  repository = "https://charts.kubewarden.io"
  chart      = "kubewarden-defaults"
  version    = "2.0.0"

  values = [
    file("${path.module}/helm/values.yml")
  ]

  namespace        = "kubewarden"

  depends_on = [ helm_release.kubewarden_crds, helm_release.kubewarden_controller ]
}