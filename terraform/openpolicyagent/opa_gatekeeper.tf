
// https://artifacthub.io/packages/helm/gatekeeper/gatekeeper

resource "helm_release" "opa_gatekeeper" {
  name       = "gatekeeper"
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  version    = "3.15.1"

  values = [
    file("${path.module}/helm/values.yml")
  ]

  namespace        = "gatekeeper-system"
  create_namespace = true
}