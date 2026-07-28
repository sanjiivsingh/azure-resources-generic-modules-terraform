variable "config" {
  type = object({
    name                            = string
    resource_group_name             = string
    location                        = string
    size                            = string
    admin_username                  = string
    admin_ssh_key                   = optional(string)
    disable_password_authentication = optional(bool, true)
    network_interface_ids           = list(string)
    tags                            = optional(map(string), {})

    os_disk = object({
      caching              = string
      storage_account_type = string
      disk_size_gb         = optional(number)
    })

    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
  })
}
