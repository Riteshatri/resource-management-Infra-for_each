output "pip_ids" {
  value = {
    for k, pip in azurerm_public_ip.public_ip : pip.name => pip.id
  }
}

output "pip_ip_addresses" {
  value = {
    for k, pip in azurerm_public_ip.public_ip : pip.name => pip.ip_address
  }
}
