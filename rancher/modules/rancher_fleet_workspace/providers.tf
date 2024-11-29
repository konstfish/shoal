terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}