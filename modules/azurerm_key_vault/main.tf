resource "azurerm_key_vault" "this" {
  name                        = var.config.name
  location                    = var.config.location
  resource_group_name         = var.config.resource_group_name
  rbac_authorization_enabled  = var.config.rbac_authorization_enabled
  enabled_for_disk_encryption = var.config.enabled_for_disk_encryption
  tenant_id                   = var.config.tenant_id
  soft_delete_retention_days  = var.config.soft_delete_retention_days
  purge_protection_enabled    = var.config.purge_protection_enabled

  sku_name = var.config.sku_name

  dynamic "access_policy" {
    for_each = var.config.access_policy
    iterator = policy
    content {
      tenant_id = policy.value.tenant_id
      object_id = policy.value.object_id

      key_permissions     = policy.value.key_permissions
      secret_permissions  = policy.value.secret_permissions
      storage_permissions = policy.value.storage_permissions
    }

  }
}
