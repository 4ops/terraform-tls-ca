output "algorithm" {
  value = tls_private_key.this.algorithm

  description = "This CA key algorithm."
}

output "key" {
  value     = local.key
  sensitive = true

  description = "Private key in PEM format."
}

output "cert" {
  value = local.cert

  description = "Certificate in PEM format."
}

output "cert_request" {
  value = local.csr

  description = "Certificate request for creating certificate externally. Content in PEM format."
}

output "signed" {
  value = { for id, res in tls_locally_signed_cert.requested : id => res.cert_pem }

  description = "Signed certificates in PEM format."
}
