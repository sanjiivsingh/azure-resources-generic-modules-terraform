resource "azurerm_bastion_host" "this" {
  name                = var.config.name
  location            = var.config.location
  resource_group_name = var.config.resource_group_name
  sku                 = var.config.sku
  tags                = var.config.tags

  ip_configuration {
    name                 = var.config.ip_configuration.name
    subnet_id            = var.config.ip_configuration.subnet_id
    public_ip_address_id = var.config.ip_configuration.public_ip_address_id
  }
}
