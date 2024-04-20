terraform {

}

provider "kubernetes" {
  config_path = "${path.module}/../../tetra/ansible/artifacts/tetra.yml"
}