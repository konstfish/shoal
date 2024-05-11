resource "helm_release" "istio" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = true

  set {
    name  = "defaultRevision"
    value = "default"
  }
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"

  set {
    name  = "defaults.global.meshID"
    value = var.mesh_id
  }

  set {
    name  = "defaults.global.multiCluster.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "defaults.global.multiCluster.enabled"
    value = var.multicluster_enabled
  }

  set {
    name  = "defaults.global.network"
    value = var.cluster_name
  }

  depends_on = [helm_release.istio]
}

/*resource "helm_release" "istio_ingress" {
  name             = "istio-ingress"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "istio-ingress"
  create_namespace = true

  values = [
    file("${path.module}/cluster/helm/istio/values.yml")
  ]

  depends_on = [ helm_release.istiod ]
}

resource "helm_release" "kiali" {
  name             = "kiali"
  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-server"
  namespace        = "istio-system"

  depends_on = [ helm_release.istiod ]
}*/