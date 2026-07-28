resource "azurerm_network_interface" "this" {
  name                = var.config.name
  location            = var.config.location
  resource_group_name = var.config.resource_group_name
  tags                = var.config.tags

  dynamic "ip_configuration" {
    for_each = var.config.ip_configurations
    content {
      name                          = ip_configuration.value.name
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address            = ip_configuration.value.private_ip_address
    }
  }
}
