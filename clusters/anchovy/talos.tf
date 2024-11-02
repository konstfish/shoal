resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = "https://10.0.2.11:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  depends_on = [oci_core_instance.arm_nodes]
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = "https://10.0.2.11:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  depends_on = [oci_core_instance.amd_nodes, oci_core_instance.arm_nodes]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [oci_core_instance.arm_nodes[0].public_ip]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = oci_core_instance.arm_nodes[0].public_ip

  config_patches = [
    yamlencode({
      machine : {
        network : {
          hostname : oci_core_instance.arm_nodes[0].display_name
          interfaces : [
            {
              interface : "eth0"
              addresses : ["${oci_core_instance.arm_nodes[0].private_ip}/24"]
            }
          ]
        }
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "amd_workers" {
  count = var.amd_count

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = oci_core_instance.amd_nodes[count.index].public_ip

  config_patches = [
    yamlencode({
      machine : {
        network : {
          hostname : oci_core_instance.amd_nodes[count.index].display_name
          interfaces : [
            {
              interface : "eth0"
              addresses : ["${oci_core_instance.amd_nodes[count.index].private_ip}/24"]
            }
          ]
        }
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "arm_workers" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = oci_core_instance.arm_nodes[1].public_ip

  config_patches = [
    yamlencode({
      machine : {
        network : {
          hostname : oci_core_instance.arm_nodes[1].display_name
          interfaces : [
            {
              interface : "eth0"
              addresses : ["${oci_core_instance.arm_nodes[1].private_ip}/24"]
            }
          ]
        }
      }
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [
    talos_machine_configuration_apply.controlplane
  ]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = oci_core_instance.arm_nodes[0].public_ip
}