resource "azurerm_public_ip" "this" {
  name                = var.config.name
  resource_group_name = var.config.resource_group_name
  location            = var.config.location
  allocation_method   = var.config.allocation_method
  tags                = var.config.tags
}