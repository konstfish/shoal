resource "hcloud_load_balancer" "lb" {
  name               = "${var.cluster_name}-lb"
  load_balancer_type = var.cluster_load_balancer_type
  location           = var.hetzner_location
  labels             = var.hetzner_labels
}

resource "hcloud_load_balancer_network" "lb_network" {
  load_balancer_id        = hcloud_load_balancer.lb.id
  network_id              = hcloud_network.default.id
  ip                      = cidrhost(var.cluster_network_subnet_range, 5)
  enable_public_interface = false
}

resource "hcloud_load_balancer_target" "lb_target" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.lb.id
  label_selector   = "role=controller"
  use_private_ip   = true

  depends_on = [
    hcloud_load_balancer_network.lb_network
  ]
}

resource "hcloud_load_balancer_service" "lb_service_6443" {
  load_balancer_id = hcloud_load_balancer.lb.id
  protocol         = "tcp"

  listen_port      = 6443
  destination_port = 6443

  health_check {
    protocol = "tcp"
    port     = 6443

    interval = 10
    timeout  = 5
  }

  depends_on = [
    hcloud_load_balancer_target.lb_target
  ]
}