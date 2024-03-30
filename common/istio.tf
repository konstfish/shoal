resource "kubernetes_namespace" "istio_guppy" {
  provider         = kubernetes.guppy

  metadata {
    name = "istio-system"
    labels = {
      "field.cattle.io/projectId" = "system"
      "topology.istio.io/network" = "network1"
    }
    annotations = {
      "management.cattle.io/system-namespace" : "true"
    }
  }

  lifecycle {
    ignore_changes = [
      metadata.0.labels,
      metadata.0.annotations,
    ]
  }
}

resource "helm_release" "istio_guppy" {
  provider         = helm.guppy
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"

  set {
    name = "defaultRevision"
    value = "default"
  }

  depends_on = [ kubernetes_namespace.istio_guppy ]
}

resource "kubernetes_namespace" "istio_tetra" {
  provider         = kubernetes.tetra

  metadata {
    name = "istio-system"
    labels = {
      "field.cattle.io/projectId" = "system"
      "topology.istio.io/network" = "network2"
    }
    annotations = {
      "management.cattle.io/system-namespace" : "true"
    }
  }

  lifecycle {
    ignore_changes = [
      metadata.0.labels,
      metadata.0.annotations,
    ]
  }
}
resource "helm_release" "istio_tetra" {
  provider         = helm.tetra
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"

  set {
    name = "defaultRevision"
    value = "default"
  }

  depends_on = [ kubernetes_namespace.istio_tetra ]
}

// Istio control plane guppy
resource "helm_release" "istiod_guppy" {
  provider         = helm.guppy
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"

  set {
    name = "defaults.global.meshID"
    value = "shoal"
  }

  set {
    name = "defaults.global.multiCluster.clusterName"
    value = "guppy"
  }

  set {
    name = "defaults.global.multiCluster.enabled"
    value = true
  }

  set {
    name = "defaults.global.network"
    value = "guppy"
  }

  set {
    name = "defaults.global.externalIstiod"
    value = true
  }

  depends_on = [ helm_release.istio_guppy ]
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

// Istio control plane tetra
resource "helm_release" "istiod_tetra" {
  provider         = helm.tetra
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"

  set {
    name = "defaults.global.meshID"
    value = "shoal"
  }

  set {
    name = "defaults.global.multiCluster.clusterName"
    value = "tetra"
  }

  set {
    name = "defaults.global.multiCluster.enabled"
    value = true
  }

  set {
    name = "defaults.global.network"
    value = "tetra"
  }

  depends_on = [ helm_release.istio_tetra ]
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

resource "helm_release" "kiali" {
  provider         = helm.guppy
  name             = "kiali"
  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-server"
  namespace        = "istio-system"

  depends_on = [ helm_release.istiod_tetra ]
}