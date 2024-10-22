terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.44"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.2"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/../barracuda/.terraform/modules/k3s/artifacts/barracuda.yml"
    insecure    = "true"
  }
}

provider "kubernetes" {
  config_path = "${path.module}/../barracuda/.terraform/modules/k3s/artifacts/barracuda.yml"
  insecure    = "true"
}