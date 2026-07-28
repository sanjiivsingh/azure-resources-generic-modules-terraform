resource "azurerm_resource_group" "this" {
  name     = var.config.name
  location = var.config.location
  tags     = var.config.tags
}
