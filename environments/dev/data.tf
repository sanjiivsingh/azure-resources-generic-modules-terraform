data "azurerm_client_config" "current" {}
data "azurerm_key_vault" "this" {
  name                = var.key_vault.name
  resource_group_name = var.key_vault.resource_group_name
}
data "azurerm_key_vault_secret" "username" {
  name         = var.key_vault.username
  key_vault_id = data.azurerm_key_vault.this.id
}
data "azurerm_key_vault_secret" "password" {
  name         = var.key_vault.password
  key_vault_id = data.azurerm_key_vault.this.id
}
data "azurerm_key_vault_secret" "public_key" {
  name         = var.key_vault.public_key
  key_vault_id = data.azurerm_key_vault.this.id
}