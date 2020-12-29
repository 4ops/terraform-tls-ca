variable "signed_cert" {
  type    = string
  default = ""

  description = "Signed cert request content."
}

variable "self_signed" {
  type    = bool
  default = true

  description = "If true, root CA will be created."
}

variable "allowed_uses" {
  type = list(string)

  default = [
    "digital_signature",
    "key_encipherment",
    "cert_signing",
  ]

  description = "List of keywords each describing a use that is permitted for the issued certificate. Affects self-signed certificate only."
}

variable "days" {
  type        = number
  default     = 3650
  description = "The number of days after initial issuing that the certificate will become invalid. Default is 10 years. Affects only self signed certificate."

  validation {
    condition     = var.days > 0
    error_message = "Value must be a positive."
  }
}

variable "common_name" {
  type    = string
  default = "ca"

  description = "Common name."
}

variable "algorithm" {
  type    = string
  default = "RSA"

  validation {
    condition     = contains(["ECDSA", "RSA"], var.algorithm)
    error_message = "Must be set only to `RSA` or `ECDSA`."
  }

  description = "The name of the algorithm to use for the key. Currently-supported values are `RSA` and `ECDSA`."
}

variable "ecdsa_curve" {
  type    = string
  default = "P384"

  validation {
    condition     = contains(["P224", "P256", "P384", "P521"], var.ecdsa_curve)
    error_message = "Value must be one of: `P224`, `P256`, `P384`, `P521`."
  }

  description = "When algorithm is `ECDSA`, the name of the elliptic curve to use."
}

variable "rsa_bits" {
  type        = number
  default     = 4096
  description = "When algorithm is `RSA`, the size of the generated RSA key in bits."

  validation {
    condition     = var.rsa_bits >= 1024 && var.rsa_bits <= 4096
    error_message = "Value must be in range: 1024..4096."
  }
}

variable "sign" {
  type = map(object({
    cert_request_pem   = string
    is_ca_certificate  = bool
    allowed_uses       = list(string)
    set_subject_key_id = bool
    days               = number
  }))

  default = {}

  description = "Map of certificate signing requests. The key of the item is not used."
}
