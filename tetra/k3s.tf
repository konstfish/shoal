locals {
  controller_nodes = [for i in range(var.cluster_controller_node_count) : {
    name             = hcloud_server.controller_nodes[i].name
    ansible_host     = hcloud_server.controller_nodes[i].network.*.ip[0]
    ansible_ssh_host = hcloud_server.controller_nodes[i].ipv4_address
  }]
  worker_nodes = [for i in range(var.cluster_node_count) : {
    name             = hcloud_server.worker_nodes[i].name
    ansible_host     = hcloud_server.worker_nodes[i].network.*.ip[0]
    ansible_ssh_host = hcloud_server.worker_nodes[i].ipv4_address
  }]
}

output "controller_node_list" {
  value = local.controller_nodes
}

output "worker_node_list" {
  value = local.worker_nodes
}


module "k3s" {
  source = "git::https://github.com/konstfish/k3s-ansible.git"

  controller_nodes = local.controller_nodes
  worker_nodes     = local.worker_nodes

  ansible_user         = "root"
  ansible_ssh_key      = tls_private_key.ansible.private_key_openssh
  ansible_ssh_key_path = "./artifacts/ssh_key"

  user_name   = "david"
  github_user = "konstfish"

  cluster_k3s_version = var.cluster_k3s_version
  cluster_token       = var.cluster_token
  cluster_name        = "tetra"
  cluster_type        = "hetzner"

  lb_public_address   = hcloud_load_balancer_network.lb_network.ip
  lb_internal_address = hcloud_load_balancer_network.lb_network.ip
  lb_interface        = "enp7s0"
  lb_port             = 6443

  cluster_cidr = "10.44.0.0/16"
  service_cidr = "10.45.0.0/16"

  extra_arguments = "--kubelet-arg='cloud-provider=external'"
  extra_arguments_server = "--disable-cloud-controller"
  extra_arguments_agent = ""
}