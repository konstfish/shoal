terraform {

}

provider "kubernetes" {
  config_path = "${path.module}/../../guppy/terraform/k3s.yaml"
}