data "kubernetes_service" "nginx_ingress_guppy" {
  provider = kubernetes.guppy

  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

data "kubernetes_service" "nginx_ingress_tetra" {
  provider = kubernetes.tetra

  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

output "nginx_ingress_external_ip" {
  value = tolist(data.kubernetes_service.nginx_ingress_tetra.spec.0.external_ips)[0]
}