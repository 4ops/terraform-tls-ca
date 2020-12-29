# Certificate authority

Creates self-signed or externally signed certificate authority.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| tls | ~> 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| tls | ~> 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| algorithm | The name of the algorithm to use for the key. Currently-supported values are `RSA` and `ECDSA`. | `string` | `"RSA"` | no |
| allowed\_uses | List of keywords each describing a use that is permitted for the issued certificate. Affects self-signed certificate only. | `list(string)` | <pre>[<br>  "digital_signature",<br>  "key_encipherment",<br>  "cert_signing"<br>]</pre> | no |
| common\_name | Common name. | `string` | `"ca"` | no |
| days | The number of days after initial issuing that the certificate will become invalid. Default is 10 years. Affects only self signed certificate. | `number` | `3650` | no |
| ecdsa\_curve | When algorithm is `ECDSA`, the name of the elliptic curve to use. | `string` | `"P384"` | no |
| rsa\_bits | When algorithm is `RSA`, the size of the generated RSA key in bits. | `number` | `4096` | no |
| self\_signed | If true, root CA will be created. | `bool` | `true` | no |
| sign | Map of certificate signing requests. The key of the item is not used. | <pre>map(object({<br>    cert_request_pem   = string<br>    is_ca_certificate  = bool<br>    allowed_uses       = list(string)<br>    set_subject_key_id = bool<br>    days               = number<br>  }))</pre> | `{}` | no |
| signed\_cert | Signed cert request content. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| algorithm | This CA key algorithm. |
| cert | Certificate in PEM format. |
| cert\_request | Certificate request for creating certificate externally. Content in PEM format. |
| key | Private key in PEM format. |
| signed | Signed certificates in PEM format. |

