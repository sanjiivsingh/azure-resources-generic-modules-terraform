module "resource_group" {
  for_each = var.resource_groups
  source   = "../../modules/azurerm_resource_group"
  config   = local.resource_groups[each.key]
}

module "virtual_network" {
  for_each = var.virtual_networks
  source   = "../../modules/azurerm_virtual_network"
  config   = local.virtual_networks[each.key]
}

module "subnet" {
  for_each = var.subnets
  source   = "../../modules/azurerm_subnet"
  config   = local.subnets[each.key]
}

module "public_ip" {
  for_each = var.public_ips
  source   = "../../modules/azurerm_public_ip"
  config   = local.public_ips[each.key]
}

module "nsg" {
  for_each = var.nsgs
  source   = "../../modules/azurerm_nsg"
  config   = local.nsgs[each.key]
}

module "nsg_association" {
  for_each = var.nsg_associations
  source   = "../../modules/azurerm_nsg_association"
  config   = local.nsg_associations[each.key]
}

module "network_interface" {
  for_each = var.network_interfaces
  source   = "../../modules/azurerm_network_interface"
  config   = local.network_interfaces[each.key]
}

module "bastion_host" {
  for_each = var.bastion_hosts
  source   = "../../modules/azurerm_bastion_host"
  config   = local.bastion_hosts[each.key]
}

module "linux_virtual_machine" {
  for_each = var.linux_vms
  source   = "../../modules/azurerm_linux_virtual_machine"
  config   = local.linux_vms[each.key]
}

module "application_gateway" {
  for_each = var.application_gateways
  source   = "../../modules/azurerm_application_gateway"
  config   = local.application_gateways[each.key]
}

module "key_vault" {
  for_each = var.key_vaults
  source   = "../../modules/azurerm_key_vault"
  config   = local.key_vaults[each.key]
}
