resource "azurerm_virtual_network" "this" {
  name                = var.config.name
  location            = var.config.location
  resource_group_name = var.config.resource_group_name
  address_space       = var.config.address_space
  tags                = var.config.tags
}

