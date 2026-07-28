resource "azurerm_subnet" "this" {
  name                 = var.config.name
  resource_group_name  = var.config.resource_group_name
  virtual_network_name = var.config.virtual_network_name
  address_prefixes     = var.config.address_prefixes
}
