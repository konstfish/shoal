resource "oci_core_instance" "amd_nodes" {
  count = var.amd_count

  display_name = "kf-orc-amd-0${count.index + 1}"

  availability_config {
    is_live_migration_preferred = "true"
    recovery_action             = "RESTORE_INSTANCE"
  }
  availability_domain = "SaEV:EU-FRANKFURT-1-AD-3"
  compartment_id      = var.ocid_compartment_id
  create_vnic_details {
    assign_ipv6ip             = "false"
    assign_private_dns_record = "true"
    assign_public_ip          = "true"
    private_ip                = "10.0.2.2${count.index + 1}"
    hostname_label            = "kf-orc-amd-0${count.index + 1}"
    nsg_ids                   = ["ocid1.networksecuritygroup.oc1.eu-frankfurt-1.aaaaaaaanyigx7n2bcjtkja7fbotigwsow7itgqhfmnlnqi2k4zpjgz255wq"]
    subnet_id                 = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaa7o5hmlt7esm6zikl545dwff225m7zkq7xv5gkfoit4yb6oa5rjfq"
  }
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  metadata = {
    "ssh_authorized_keys" = data.external.github_ssh_key.result.ssh_key
  }
  shape = var.amd_shape
  source_details {
    source_id   = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaahdjmpsmecotm4zt5qa3ddjpxvt4yjtwp5z7zjaczd4f7ktysvpiq"
    source_type = "image"
  }
}

resource "oci_core_instance" "arm_nodes" {
  count = var.arm_count

  display_name = "kf-orc-arm-0${count.index + 1}"

  availability_config {
    is_live_migration_preferred = "true"
    recovery_action             = "RESTORE_INSTANCE"
  }
  availability_domain = "SaEV:EU-FRANKFURT-1-AD-2"
  compartment_id      = var.ocid_compartment_id
  create_vnic_details {
    assign_ipv6ip             = "false"
    assign_private_dns_record = "true"
    assign_public_ip          = "true"
    private_ip                = "10.0.2.1${count.index + 1}"
    hostname_label            = "kf-orc-arm-0${count.index + 1}"
    nsg_ids                   = ["ocid1.networksecuritygroup.oc1.eu-frankfurt-1.aaaaaaaanyigx7n2bcjtkja7fbotigwsow7itgqhfmnlnqi2k4zpjgz255wq"]
    subnet_id                 = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaa7o5hmlt7esm6zikl545dwff225m7zkq7xv5gkfoit4yb6oa5rjfq"
  }
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  metadata = {
    "ssh_authorized_keys" = data.external.github_ssh_key.result.ssh_key
  }
  shape = var.arm_shape
  shape_config {
    memory_in_gbs = "12"
    ocpus         = "2"
  }
  source_details {
    source_id   = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaakilzsb5svx7x2ltbqa7lk7gxpn3mfudbozfmuwmeftkokkmeitdq"
    source_type = "image"
  }
}
