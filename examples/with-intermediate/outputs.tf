output "root_ca_cert" {
  value = module.root_example.cert
}

output "intermediate_ca_cert" {
  value = module.intermediate_example.cert
}

output "server_cert" {
  value = module.intermediate_example.signed["my_web_server"]
}
