locals {
  name                            = var.config.name
  resource_group_name             = var.config.resource_group_name
  location                        = var.config.location
  size                            = var.config.size
  admin_username                  = var.config.admin_username
  admin_ssh_key                   = var.config.admin_ssh_key
  disable_password_authentication = var.config.disable_password_authentication
  network_interface_ids           = var.config.network_interface_ids
  tags                            = var.config.tags

  os_disk                = var.config.os_disk
  source_image_reference = var.config.source_image_reference
}
