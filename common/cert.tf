resource "tls_private_key" "ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem       = tls_private_key.ca.private_key_pem
  is_ca_certificate     = true
  set_subject_key_id    = true
  validity_period_hours = 87600
  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
  subject {
    common_name = "root.linkerd.cluster.local"
  }
}

resource "tls_private_key" "issuer" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "issuer" {
  private_key_pem = tls_private_key.issuer.private_key_pem
  subject {
    common_name = "identity.linkerd.cluster.local"
  }
}

resource "tls_locally_signed_cert" "issuer" {
  cert_request_pem      = tls_cert_request.issuer.cert_request_pem
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  is_ca_certificate     = true
  set_subject_key_id    = true
  validity_period_hours = 8760
  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
}