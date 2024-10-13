resource "tls_private_key" "ansible" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "ansible" {
  name       = "ansible-${var.cluster_name}"
  public_key = tls_private_key.ansible.public_key_openssh
}