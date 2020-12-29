terraform {
  required_version = ">= 0.13"

  required_providers {
    tls = "~> 3.0.0"
  }
}

locals {
  key  = tls_private_key.this.private_key_pem
  cert = var.self_signed ? join("", tls_self_signed_cert.this.*.cert_pem) : var.signed_cert
  csr  = join("", tls_cert_request.this.*.cert_request_pem)
}

resource "tls_private_key" "this" {
  algorithm   = var.algorithm
  ecdsa_curve = var.ecdsa_curve
  rsa_bits    = var.rsa_bits
}

resource "tls_cert_request" "this" {
  count = var.self_signed ? 0 : 1

  key_algorithm   = tls_private_key.this.algorithm
  private_key_pem = tls_private_key.this.private_key_pem

  subject {
    common_name = var.common_name
  }
}

resource "tls_self_signed_cert" "this" {
  count = var.self_signed ? 1 : 0

  key_algorithm   = tls_private_key.this.algorithm
  private_key_pem = tls_private_key.this.private_key_pem
  allowed_uses    = var.allowed_uses

  subject {
    common_name = var.common_name
  }

  is_ca_certificate     = true
  validity_period_hours = var.days * 24
}

resource "tls_locally_signed_cert" "requested" {
  for_each = var.sign

  cert_request_pem      = each.value.cert_request_pem
  ca_key_algorithm      = tls_private_key.this.algorithm
  ca_private_key_pem    = local.key
  ca_cert_pem           = local.cert
  allowed_uses          = each.value.allowed_uses
  validity_period_hours = each.value.days * 24
  is_ca_certificate     = each.value.is_ca_certificate
  set_subject_key_id    = each.value.set_subject_key_id
}
