// auth config
resource "rancher2_auth_config_github" "github" {
  client_id             = var.gh_oauth_client_id
  client_secret         = var.gh_oauth_client_secret
  access_mode           = "required"
  allowed_principal_ids = ["github_org://${data.github_organization.org.id}"]
}

// clusters
/// data for now
//data "rancher2_cluster" "guppy" {
//  name = "guppy"
//}

data "rancher2_cluster" "guppy" {
  name = "guppy"
}


data "rancher2_cluster" "tetra" {
  name = "tetra"
}

/*resource "rancher2_cluster" "guppy" {
  name = "guppy"
}

resource "rancher2_cluster" "tetra" {
  name = "tetra"
}*/

// settings
resource "rancher2_setting" "show_local_clusters" {
  name  = "hide-local-cluster"
  value = "true"
}