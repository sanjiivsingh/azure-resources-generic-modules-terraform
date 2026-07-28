resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = var.config.subnet_id
  network_security_group_id = var.config.network_security_group_id
}

