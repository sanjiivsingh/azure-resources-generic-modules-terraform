data "azurerm_client_config" "current" {}
data "azurerm_key_vault_secret" "vm_username" {
  name         = "username"
  key_vault_id = module.key_vault["main_kv"].key_vault
}
data "azurerm_key_vault_secret" "vm_password" {
  name         = "password"
  key_vault_id = module.key_vault["main_kv"].key_vault
}