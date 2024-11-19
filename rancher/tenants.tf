locals {
  project_user_map = {
    for login, user in data.github_user.org_users :
    user.username => user.id
  }

  tenant_index = yamldecode(file("tenants.yaml"))
  defaults = local.tenant_index.defaults

  tenant_index_merged = {
    for name, tenant in local.tenant_index.tenants : name => {
      short = tenant.short
      namespaces = try(tenant.namespaces, local.defaults.namespaces)
    }
  }
}

output "tenant_index_merged" { 
  value = local.tenant_index_merged
}

resource "kubernetes_namespace" "mgmt_namespace" {
  metadata {
    name = "shoal-mgmt"
  }
}

// this has to run at the start, since we need to pre-provision users
module "tenant_projects" {
  for_each = local.project_user_map
  source = "./modules/rancher_project"

  project_prefix = "tenant"
  project_name   = each.key
  tenant_map     = { (each.key) = each.value }
  cluster_id     = data.rancher2_cluster.tetra.id
}

module "tenant_namespaces" {
  for_each = local.tenant_index_merged
  source = "./modules/rancher_namespace"

  project_id        = module.tenant_projects[each.key].project_id

  tenant_id         = local.project_user_map[each.key]
  tenant_name       = each.key

  namespace_prefix  = local.tenant_index[each.key]["short"]
  namespace_name    = "playground"

  depends_on = [module.tenant_projects, kubernetes_namespace.mgmt_namespace]
}

module "workspace" {
  source =""
  for_each = {
    for tenant in flatten([
      for namespace in local.yaml_data : [
        for workspace in team.workspaces : {
          workspace = workspace
          team      = team
        }
      ]
    ])
    : item.workspace.workspace_name => item
  }

  something = module.team[each.value.team.team_name].something
}