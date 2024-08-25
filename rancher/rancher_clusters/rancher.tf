// auth config
resource "rancher2_auth_config_github" "github" {
  client_id             = var.gh_oauth_client_id
  client_secret         = var.gh_oauth_client_secret
  access_mode           = "required"
  allowed_principal_ids = ["github_org://${data.github_organization.org.id}"]
}

// need to create clusters manually, since the id is "random" with terraform 
// https://github.com/rancher/terraform-provider-rancher2/blob/master/rancher2/data_source_rancher2_cluster.go#L227

// settings
//resource "rancher2_setting" "show_local_clusters" {
//  name  = "hide-local-cluster"
//  value = "true"
//}