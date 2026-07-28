variable "config" {
  type = object({
    name                        = string
    location                    = string
    resource_group_name         = string
    rbac_authorization_enabled  = bool
    enabled_for_disk_encryption = bool
    tenant_id                   = string
    soft_delete_retention_days  = number
    purge_protection_enabled    = bool

    sku_name = string

    access_policy = map(object({
      tenant_id           = string
      object_id           = string
      key_permissions     = list(string)
      secret_permissions  = list(string)
      storage_permissions = list(string)
    }))

  })
}
