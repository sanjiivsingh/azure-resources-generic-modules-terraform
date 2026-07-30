variable "config" {
  type = object({
    name                  = string
    resource_group_name   = string
    location              = string
    size                  = string
    network_interface_ids = list(string)

    os_disk = object({
      caching              = string
      storage_account_type = string
    })
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    authentication = object({
      type             = string
      admin_username   = string
      admin_password   = optional(string)
      admin_public_key = optional(string)
    })
    extensions = optional(map(object({
      publisher                  = string
      type                       = string
      type_handler_version       = string
      auto_upgrade_minor_version = optional(bool, true)
      settings                   = optional(any)
      protected_settings         = optional(any)
    })), {})
  })

  validation {
    condition = contains(
      ["ssh", "password", "entra"],
      var.config.authentication.type
    )

    error_message = "Authentication must be ssh, password or entra."
  }
}
