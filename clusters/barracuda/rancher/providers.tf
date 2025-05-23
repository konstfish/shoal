terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.44"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.5.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/../.terraform/modules/k3s/artifacts/barracuda.yml"
    insecure    = "true"
  }
}

provider "kubernetes" {
  config_path = "${path.module}/../.terraform/modules/k3s/artifacts/barracuda.yml"
  insecure    = "true"
}