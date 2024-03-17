terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.2"
    }
  }
}

provider "http" {}

provider "tls" {}

provider "kubernetes" {
  alias = "tetra"

  config_path = "${path.module}/../tetra/ansible/artifacts/tetra.yml"
  insecure    = "true"
}

provider "helm" {
  alias = "tetra"

  kubernetes {
    config_path = "${path.module}/../tetra/ansible/artifacts/tetra.yml"
    insecure    = "true"
  }
}

provider "kubernetes" {
  alias = "guppy"

  config_path = "${path.module}/../guppy/terraform/k3s.yaml"
}

provider "helm" {
  alias = "guppy"

  kubernetes {
    config_path = "${path.module}/../guppy/terraform/k3s.yaml"
  }
}