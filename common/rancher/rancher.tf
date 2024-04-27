// auth config
resource "rancher2_auth_config_github" "github" {
  client_id             = var.gh_oauth_client_id
  client_secret         = var.gh_oauth_client_secret
  access_mode           = "required"
  allowed_principal_ids = ["github_org://${data.github_organization.org.id}"]
}

// clusters
/// data for now
data "rancher2_cluster" "guppy" {
  name = "guppy"
}

data "rancher2_cluster" "tetra" {
  name = "tetra"
}

// projects
resource "rancher2_project" "user_projects" {
  for_each = local.user_map

  name       = lower(each.value.login)
  cluster_id = data.rancher2_cluster.tetra.id

  resource_quota {
    project_limit {
      limits_cpu       = "2000m"
      limits_memory    = "2000Mi"
      requests_storage = "30Gi"
    }
    namespace_default_limit {
      limits_cpu       = "2000m"
      limits_memory    = "2000Mi"
      requests_storage = "30Gi"
    }
  }
  container_resource_limit {
    limits_cpu      = "150m"
    limits_memory   = "100Mi"
    requests_cpu    = "50m"
    requests_memory = "50Mi"
  }
}

resource "rancher2_project_role_template_binding" "user_projects_binding" {
  for_each = local.user_map

  name              = lower("template-binding-${each.value.login}")
  project_id        = lower(rancher2_project.user_projects[each.value.login].id)
  role_template_id  = "project-owner"
  user_principal_id = "github_user://${data.github_user.org_users[each.value.login].id}"
}