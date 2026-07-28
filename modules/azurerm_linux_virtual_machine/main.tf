resource "azurerm_linux_virtual_machine" "this" {
  name                            = local.name
  resource_group_name             = local.resource_group_name
  location                        = local.location
  size                            = local.size
  admin_username                  = local.admin_username
  disable_password_authentication = local.disable_password_authentication
  network_interface_ids           = local.network_interface_ids
  tags                            = local.tags

  dynamic "admin_ssh_key" {
    for_each = local.admin_ssh_key != null ? [local.admin_ssh_key] : []
    content {
      username   = local.admin_username
      public_key = admin_ssh_key.value
    }
  }

  os_disk {
    caching              = local.os_disk.caching
    storage_account_type = local.os_disk.storage_account_type
    disk_size_gb         = local.os_disk.disk_size_gb
  }

  source_image_reference {
    publisher = local.source_image_reference.publisher
    offer     = local.source_image_reference.offer
    sku       = local.source_image_reference.sku
    version   = local.source_image_reference.version
  }
}
