terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 2.12.1"
    }
  }
}


provider "helm" {
  kubernetes {
    config_path = "/Users/david/.kube/config"
    insecure    = "true"
  }
}

provider "kubernetes" {
  config_path = "/Users/david/.kube/config"
  insecure    = "true"
}