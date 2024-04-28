// fleet projects
resource "kubernetes_manifest" "fleet_project" {
  for_each = local.user_map

  manifest = {
    "apiVersion" = "management.cattle.io/v3"
    "kind"       = "FleetWorkspace"
    "metadata" = {
      "name"      = lower("fleet-${each.value.login}")
    }
  }
}

// introduce a delay to ensure the fleet project is created before the helm release
resource "null_resource" "fleet_delay" {
  provisioner "local-exec" {
    command = "sleep 10"
  }

  depends_on = [ kubernetes_manifest.fleet_project ]
}

resource "helm_release" "fleet_project_bindings" {
  for_each = local.user_map

  name       = lower("fleet-project-${each.value.login}")
  repository = "./helm"
  chart      = "fleet-project"

  set {
    name  = "tenant"
    value = lower(each.value.login)
  }

  set {
    name  = "tenantId"
    value = local.github_user_to_id_map["github_user://${data.github_user.org_users[each.value.login].id}"]
  }

  depends_on = [ null_resource.fleet_delay ]
}

resource "rancher2_global_role_binding" "fleet_project_bindings" {
  for_each = local.user_map

  name = lower("fleet-project-${each.value.login}")
  global_role_id = lower("fleet-${each.value.login}")
  user_id = local.github_user_to_id_map["github_user://${data.github_user.org_users[each.value.login].id}"]

  depends_on = [ helm_release.fleet_project_bindings ]
}