// OAuth Zero
resource "helm_release" "oauth2_proxy_zero" {
  name             = "oauth2-proxy-${var.oauth_class}"
  repository       = "https://oauth2-proxy.github.io/manifests"
  chart            = "oauth2-proxy"
  namespace        = "oauth-proxy"
  create_namespace = true

  values = [
    templatefile("${path.module}/helm/template.yml.tpl", {
      domain = var.oauth_domain
      class = var.oauth_class
      github_team = var.oauth_github_team
    })
  ]

  set {
    name  = "config.clientID"
    value = var.oauth_client_id
  }

  set {
    name  = "config.clientSecret"
    value = var.oauth_client_secret
  }

  set {
    name  = "config.cookieSecret"
    value = var.oauth_cookie_secret
  }
}