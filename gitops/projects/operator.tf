resource "kubernetes_manifest" "operator_grafana" {
  manifest = yamldecode(file("${path.module}/operator/grafana.yaml"))
}

resource "kubernetes_manifest" "operator_tempo" {
  manifest = yamldecode(file("${path.module}/operator/tempo.yaml"))
}

resource "kubernetes_manifest" "operator_kiali" {
  manifest = yamldecode(file("${path.module}/operator/kiali.yaml"))
}