locals {
  controller_nodes = [
    {
      name             = "${var.cluster_name}-0"
      ansible_host     = "10.0.1.51"
      ansible_ssh_host = "10.0.1.51"
    },
    {
      name             = "${var.cluster_name}-1"
      ansible_host     = "10.0.1.52"
      ansible_ssh_host = "10.0.1.52"
    },
    {
      name             = "${var.cluster_name}-2"
      ansible_host     = "10.0.1.53"
      ansible_ssh_host = "10.0.1.53"
    }
  ]
}

output "controller_node_list" {
  value = local.controller_nodes
}

module "k3s" {
  source = "git::https://github.com/konstfish/k3s-ansible.git"

  controller_nodes = local.controller_nodes
  worker_nodes     = null

  ansible_user         = "pi"
  ansible_ssh_key      = null
  ansible_ssh_key_path = "/Users/david/.ssh/id_ansible"

  user_name   = "david"
  github_user = "konstfish"

  cluster_k3s_version = var.cluster_k3s_version
  cluster_token       = var.cluster_token
  cluster_name        = "guppy"
  cluster_type        = "raspberry"

  lb_public_address   = "10.0.1.50"
  lb_internal_address = "10.0.1.50"
  lb_interface        = "eth0"
  lb_port             = 6440

  cluster_cidr = "10.44.0.0/16"
  service_cidr = "10.45.0.0/16"
}