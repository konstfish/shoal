terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "6.0.0"
    }
  }
}

provider "github" {
  token = var.gh_token
  owner = "shoal-konst-fish"
}

provider "rancher2" {
  api_url    = var.rancher_api_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
}

// kubernetes
provider "kubernetes" {
  config_path = "${path.module}/../clusters/tetra/.terraform/modules/k3s/artifacts/tetra.yml"
  insecure    = "true"
}

provider "kubernetes" {
  alias = "barracuda"

  config_path = "${path.module}/../clusters/barracuda/.terraform/modules/k3s/artifacts/barracuda.yml"
  insecure    = "true"
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/../clusters/tetra/.terraform/modules/k3s/artifacts/tetra.yml"
    insecure    = "true"
  }
}

provider "helm" {
  alias = "barracuda"
  kubernetes {
    config_path = "${path.module}/../clusters/barracuda/.terraform/modules/k3s/artifacts/barracuda.yml"
    insecure    = "true"
  }
}

provider "http" {
}