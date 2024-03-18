resource "helm_release" "istio_tetra" {
  provider         = helm.tetra
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = true

  set {
    name = "defaultRevision"
    value = "default"
  }
}

resource "helm_release" "istio_guppy" {
  provider         = helm.guppy
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = true

  set {
    name = "defaultRevision"
    value = "default"
  }
}

resource "helm_release" "istiod_tetra" {
  provider         = helm.tetra
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"

  depends_on = [ helm_release.istio_tetra ]
}

resource "helm_release" "istiod_guppy" {
  provider         = helm.guppy
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"

  depends_on = [ helm_release.istio_guppy ]
}

resource "helm_release" "istio_ingress_tetra" {
  provider         = helm.tetra
  name             = "istio-ingress"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "istio-ingress"
  create_namespace = true

  set {
    name  = "defaults.service.externalIPs[0]"
    value = tolist(data.kubernetes_service.nginx_ingress_tetra.spec.0.external_ips)[0]
  }

  values = [
    file("${path.module}/helm/istio_ingress/values.yml"),
  ]

  depends_on = [ helm_release.istiod_tetra ]
}

resource "helm_release" "istio_ingress_guppy" {
  provider         = helm.guppy
  name             = "istio-ingress"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "istio-ingress"
  create_namespace = true

  set {
    name  = "defaults.service.externalIPs[0]"
    value = tolist(data.kubernetes_service.nginx_ingress_guppy.spec.0.external_ips)[0]
  }

  values = [
    file("${path.module}/helm/istio_ingress/values.yml"),
  ]

  depends_on = [ helm_release.istiod_guppy ]
}

resource "helm_release" "kiali" {
  provider         = helm.tetra
  name             = "kiali"
  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-server"
  namespace        = "istio-system"

  depends_on = [ helm_release.istiod_tetra ]
}