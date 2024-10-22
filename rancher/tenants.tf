locals {
  project_user_map = {
    for login, user in data.github_user.org_users :
    user.username => user.id
  }
}

// this has to run at the start, since we need to pre-provision users
module "tenant_projects" {
  for_each = local.project_user_map

  source = "./modules/rancher_project"

  project_prefix = "tenant-"
  project_name   = each.key
  tenant_map     = { (each.key) = each.value }
  cluster_id     = data.rancher2_cluster.tetra.id
}

module "tenant_namespace_playgrounds" {
  for_each = local.project_user_map

  source = "./modules/rancher_namespace"

  project_id        = module.tenant_projects[each.key].project_id
  tenant_name       = each.key
  namespace_name    = substr(each.key, 0, 3)
  namespace_postfix = "-playground"

  depends_on = [module.tenant_projects]
}


