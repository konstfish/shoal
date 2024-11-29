locals {
  namespace_name = lower("${var.namespace_prefix}-${var.namespace_name}${var.namespace_postfix}")
}

resource "rancher2_namespace" "user_namespaces" {
  project_id = var.project_id

  name = local.namespace_name

  labels = merge({
    "kubernetes.io/metadata.name" = local.namespace_name
    "tenant"                      = var.tenant_name
    "ingress"                     = "true"
    "billing"                     = var.billing

    "pod-security.kubernetes.io/enforce" = "baseline"
    "pod-security.kubernetes.io/audit"   = "baseline"
    "pod-security.kubernetes.io/warn"    = "restricted"
  }, lookup(var.namespace_config, "labels", {}))

  lifecycle {
    ignore_changes = [
      container_resource_limit,
      labels["*"]
    ]
  }
}

resource "helm_release" "user_namespace_provision" {
  name       = lower("shoal-tenant-${local.namespace_name}")
  repository = "${path.module}/helm"
  chart      = "tenant-namespace"
  namespace  = "shoal-mgmt"

  set {
    name  = "targetNamespace"
    value = rancher2_namespace.user_namespaces.name
  }
  set {
    name  = "tenant"
    value = var.tenant_name
  }
  set {
    name  = "tenantId"
    value = "github_user://${var.tenant_id}"
  }

  values = [
    yamlencode(var.namespace_config)
  ]
}