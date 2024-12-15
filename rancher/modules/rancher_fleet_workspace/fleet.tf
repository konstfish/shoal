locals {
  prefixed_namespaces = [
    for ns in var.tenant_namespaces:
    "${var.namespace_prefix}-${ns}"
  ]

  allowed_namespaces = jsonencode(local.prefixed_namespaces)
}

// fleet projects
resource "kubernetes_manifest" "fleet_project" {
  manifest = {
    "apiVersion" = "management.cattle.io/v3"
    "kind"       = "FleetWorkspace"
    "metadata" = {
      "name" = lower("fleet-tenant-${var.tenant_name}")
    }
  }
}

// introduce a delay to ensure the fleet project is created before the helm release
resource "null_resource" "fleet_delay" {
  provisioner "local-exec" {
    command = "sleep 15"
  }

  depends_on = [kubernetes_manifest.fleet_project]
}

resource "helm_release" "fleet_project_bindings" {
  name       = lower("fleet-project-${var.tenant_name}")
  repository = "${path.module}/helm"
  chart      = "fleet-project"

  set {
    name  = "tenant"
    value = lower(var.tenant_name)
  }

  set {
    name  = "tenantId"
    value = var.tenant_id
  }

  values = [
    yamlencode({
      allowedNamespaces = local.prefixed_namespaces
    })
  ]
  
  depends_on = [null_resource.fleet_delay]
}

resource "rancher2_global_role_binding" "fleet_project_bindings" {
  name               = lower("fleet-tenant-${var.tenant_name}")
  global_role_id     = lower("fleet-tenant-${var.tenant_name}")
  user_id            = var.tenant_id

  depends_on = [helm_release.fleet_project_bindings]
}