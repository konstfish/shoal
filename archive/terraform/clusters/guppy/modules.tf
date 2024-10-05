// core

module "operators" {
  source = "../terraform/operators"

  depends_on = [ local_file.ansible_inventory ]
}

module "cert_manager" {
  source = "../terraform/cert_manager"

  cloudflare_api_token = var.cloudflare_api_token

  depends_on = [ module.operators ]
}

// ingress
module "ingress_cloudflare" {
  source = "../terraform/ingress_cloudflare"

  cloudflare_api_token   = var.cloudflare_api_token
  cloudflare_acount_id   = var.cloudflare_acount_id
  cloudflare_tunnel_name = "guppy"

  depends_on = [local_file.ansible_inventory]
}

module "ingress_nginx" {
  source = "../terraform/ingress_nginx"

  external_ip          = data.http.runner_public_ip.response_body
  cloudflare_api_token = var.cloudflare_api_token

  depends_on = [ local_file.ansible_inventory ]
}

module "istio" {
  source = "../terraform/istio"

  // todo

  depends_on = [ local_file.ansible_inventory ]
}

// storage
module "longhorn" {
  source = "../terraform/longhorn"

  longhorn_s3_access_key = var.longhorn_s3_access_key
  longhorn_s3_secret_key = var.longhorn_s3_secret_key
  longhorn_s3_endpoint   = var.longhorn_s3_endpoint
  longhorn_s3_bucket     = var.longhorn_s3_bucket

  depends_on = [ local_file.ansible_inventory ]
}

module "nfs" {
    source = "../terraform/storage/nfs"

    depends_on = [ local_file.ansible_inventory ]
}

// security
module "sealed_secrets" {
  source = "../terraform/sealed_secrets"

  depends_on = [ local_file.ansible_inventory ]
}