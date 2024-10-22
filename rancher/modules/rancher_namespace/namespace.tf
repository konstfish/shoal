locals {
  namespace_name = lower("${var.namespace_prefix}${var.namespace_name}${var.namespace_postfix}")
}

resource "rancher2_namespace" "user_namespaces" {
  project_id = var.project_id

  name = local.namespace_name

  labels = {
    "kubernetes.io/metadata.name" = local.namespace_name
    "tenant"                      = var.tenant_name
    "ingress"                     = "true"
    "billing"                     = var.billing

    "pod-security.kubernetes.io/enforce" = "restricted"
    "pod-security.kubernetes.io/audit"   = "baseline"
    "pod-security.kubernetes.io/warn"    = "restricted"
  }

  /*resource_quota {
    limit {
      limits_cpu       = var.namespace_resources.limits_cpu
      limits_memory    = var.namespace_resources.limits_memory
      requests_storage = var.namespace_resources.requests_storage
    }
  }
  container_resource_limit {
    limits_cpu      = var.container_resources.limits_cpu
    limits_memory   = var.container_resources.limits_memory
    requests_cpu    = var.container_resources.requests_cpu
    requests_memory = var.container_resources.requests_memory
  }*/

  lifecycle {
    ignore_changes = [
      container_resource_limit
    ]
  }
}