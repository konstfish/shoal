resource "helm_release" "linkerd_crd_tetra" {
  provider         = helm.tetra
  name             = "linkerd-crds"
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-crds"
  namespace        = "linkerd"
  create_namespace = true
}

resource "helm_release" "linkerd_crd_guppy" {
  provider         = helm.guppy
  name             = "linkerd-crds"
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-crds"
  namespace        = "linkerd"
  create_namespace = true
}

resource "helm_release" "linkerd_tetra" {
  provider   = helm.tetra
  name       = "linkerd"
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-control-plane"
  namespace  = "linkerd"

  set_sensitive {
    name  = "identityTrustAnchorsPEM"
    value = tls_locally_signed_cert.issuer.ca_cert_pem
  }

  set_sensitive {
    name  = "identity.issuer.tls.crtPEM"
    value = tls_locally_signed_cert.issuer.cert_pem
  }

  set_sensitive {
    name  = "identity.issuer.tls.keyPEM"
    value = tls_private_key.issuer.private_key_pem
  }

  depends_on = [helm_release.linkerd_crd_tetra]
}

resource "helm_release" "linkerd_guppy" {
  provider   = helm.guppy
  name       = "linkerd"
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-control-plane"
  namespace  = "linkerd"

  set_sensitive {
    name  = "identityTrustAnchorsPEM"
    value = tls_locally_signed_cert.issuer.ca_cert_pem
  }

  set_sensitive {
    name  = "identity.issuer.tls.crtPEM"
    value = tls_locally_signed_cert.issuer.cert_pem
  }

  set_sensitive {
    name  = "identity.issuer.tls.keyPEM"
    value = tls_private_key.issuer.private_key_pem
  }

  depends_on = [helm_release.linkerd_crd_guppy]
}

// get value from ingress nginx controller.service.externalIPs[0]
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


resource "helm_release" "linkerd_multicluster_tetra" {
  provider         = helm.tetra
  name             = "linkerd-multicluster"
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-multicluster"
  namespace        = "linkerd-multicluster"
  create_namespace = true

  set {
    name  = "gateway.loadBalancerIP"
    value = tolist(data.kubernetes_service.nginx_ingress_tetra.spec.0.external_ips)[0]
  }

  set {
    name  = "gateway.serviceType"
    value = "NodePort"
  }

  set {
    name = "createNamespaceMetadataJob"
    value = false
  }

  depends_on = [helm_release.linkerd_guppy, helm_release.linkerd_tetra]
}

resource "helm_release" "linkerd_multicluster_guppy" {
  provider         = helm.guppy
  name             = "linkerd-multicluster"
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-multicluster"
  namespace        = "linkerd-multicluster"
  create_namespace = true

  set {
    name  = "gateway.loadBalancerIP"
    value = tolist(data.kubernetes_service.nginx_ingress_guppy.spec.0.external_ips)[0]
  }

  set {
    name  = "gateway.serviceType"
    value = "NodePort"
  }

  set {
    name = "createNamespaceMetadataJob"
    value = false
  }

  depends_on = [helm_release.linkerd_guppy, helm_release.linkerd_tetra]
}

/*
resource "helm_release" "linkerd_viz_tetra" {
  provider         = helm.tetra
  name             = "linkerd-viz"
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-viz"
  namespace        = "linkerd-viz"
  create_namespace = true

  depends_on = [helm_release.linkerd_tetra]
}
*/