output "rgkanaam" {
  description = "Yeh humare resource group ka naam batayga."
  value       = azurerm_resource_group.MynewinfraRG.name
}
output "rgkalocation" {
  description = "Yeh humare resource group ka location batayga."
  value       = azurerm_resource_group.MynewinfraRG.location
}
output "vnetkanaam" {
  description = "Yeh humare virtual network ka naam batayga."
  value       = azurerm_virtual_network.InfraVNet.name
}

output "vnetkaaddressspace" {
  description = "Yeh humare virtual network ka address space batayga."
  value       = azurerm_virtual_network.InfraVNet.address_space
}
output "subnetkanaam" {
  description = "Yeh humare subnet ka naam batayga."
  value       = azurerm_subnet.Infrakasubnet.name
}
output "subnetkaaddressprefixes" {
  description = "Yeh humare subnet ke address prefixes batayga."
  value       = azurerm_subnet.Infrakasubnet.address_prefixes
}
output "nsgkanaam" {
  description = "Yeh humare network security group ka naam batayga."
  value       = azurerm_network_security_group.Infranetkasecurityguard.name
}

output "nsgkesecurityrules" {
  description = "Yeh humare network security group ke security rules batayga."
  value       = azurerm_network_security_group.Infranetkasecurityguard.security_rule
}
output "nickanaam" {
  description = "Yeh humare network interface card ka naam batayga."
  value       = azurerm_network_interface.InfraNIC.name
}
output "nickaipconfiguration" {
  description = "Yeh humare network interface card ke IP configuration batayga."
  value       = azurerm_network_interface.InfraNIC.ip_configuration
}
output "nickaprivateip" {
  description = "Yeh humare network interface card ka private IP address batayga."
  value       = azurerm_network_interface.InfraNIC.ip_configuration[0].private_ip_address
}
output "nickapublicip" {
  description = "Yeh humare network interface card ka public IP address batayga."
  value       = azurerm_network_interface.InfraNIC.ip_configuration[0].public_ip_address_id
}
output "publicipname" {
  description = "Yeh humare public IP address ka naam batayga."
  value       = azurerm_public_ip.InfraPIP.name
}
output "publicipaddress" {
  description = "Yeh humare public IP address batayga."
  value       = azurerm_public_ip.InfraPIP.ip_address
}

output "nicnsgassociation" {
  description = "Yeh humare NIC aur NSG ke beech association batayga."
  value       = azurerm_network_interface_security_group_association.InfraNICNSGAssociation.id
}

output "strorageaccountname" {
  description = "Yeh humare storage account ka naam hai"
  value       = azurerm_storage_account.Infrastorage_account.name
}

output "vmname" {
  description = "Yeh humare virtual machine ka naam batayga."
  value       = azurerm_virtual_machine.Infra_VM.name
}

output "vmprivateip" {
  description = "Yeh humare virtual machine ka private IP address batayga."
  value       = azurerm_network_interface.InfraNIC.ip_configuration[0].private_ip_address
}


output "bootdiagnosticreport" {# Virtual machine ke boot diagnostics storage URI ko retrieve karne ke liye output.
  description = "Yeh humare virtual machine ke boot diagnostics storage URI batayga."
  value = azurerm_virtual_machine.Infra_VM.boot_diagnostics[0].storage_uri
}