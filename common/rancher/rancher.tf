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

data "rancher2_user" "user_map" {
  for_each = local.user_map

  is_external = true
  username = lower(each.value.login)
  name = lower(each.value.login)
}