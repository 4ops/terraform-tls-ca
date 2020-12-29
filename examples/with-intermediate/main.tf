terraform {
  required_version = ">= 0.13"

  required_providers {
    tls = "~> 3.0.0"
  }
}

module "root_example" {
  source = "../../"

  sign = {
    intermediate_ca = {
      cert_request_pem   = module.intermediate_example.cert_request
      is_ca_certificate  = true
      set_subject_key_id = true
      days               = 365

      allowed_uses = [
        "digital_signature",
        "key_encipherment",
        "cert_signing",
      ]
    }
  }
}

resource "tls_cert_request" "intermediate" {
  key_algorithm   = module.intermediate_example.algorithm
  private_key_pem = module.intermediate_example.key

  subject {
    common_name = "intermediate-ca"
  }
}

module "intermediate_example" {
  source = "../../"

  self_signed = false
  signed_cert = module.root_example.signed["intermediate_ca"]

  sign = {
    my_web_server = {
      cert_request_pem   = tls_cert_request.my_web_server.cert_request_pem
      is_ca_certificate  = false
      set_subject_key_id = true
      days               = 365

      allowed_uses = [
        "digital_signature",
        "key_encipherment",
        "server_auth",
      ]
    }
  }
}

resource "tls_private_key" "my_web_server" {
  algorithm = "RSA"
}

resource "tls_cert_request" "my_web_server" {
  key_algorithm   = tls_private_key.my_web_server.algorithm
  private_key_pem = tls_private_key.my_web_server.private_key_pem

  subject {
    common_name  = "www.example.com"
    organization = "ACME Examples, Inc"
  }
}
