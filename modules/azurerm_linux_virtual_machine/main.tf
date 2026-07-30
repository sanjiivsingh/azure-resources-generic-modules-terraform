resource "azurerm_linux_virtual_machine" "this" {
  name                  = var.config.name
  resource_group_name   = var.config.resource_group_name
  location              = var.config.location
  size                  = var.config.size
  admin_username        = var.config.authentication.admin_username
  network_interface_ids = var.config.network_interface_ids

  disable_password_authentication = var.config.authentication.type != "password"
  admin_password                  = var.config.authentication.type == "password" ? var.config.authentication.admin_password : null

  dynamic "admin_ssh_key" {
    for_each = contains(["ssh", "entra"], var.config.authentication.type) ? [1] : []
    content {
      username   = var.config.authentication.admin_username
      public_key = var.config.authentication.admin_public_key
    }
  }

  os_disk {
    caching              = var.config.os_disk.caching
    storage_account_type = var.config.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.config.source_image_reference.publisher
    offer     = var.config.source_image_reference.offer
    sku       = var.config.source_image_reference.sku
    version   = var.config.source_image_reference.version
  }
  dynamic "identity" {
    for_each = var.config.authentication.type == "entra" ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
}

resource "azurerm_virtual_machine_extension" "this" {

  for_each                   = var.config.extensions
  name                       = each.key
  virtual_machine_id         = azurerm_linux_virtual_machine.this.id
  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  auto_upgrade_minor_version = each.value.auto_upgrade_minor_version
  settings = try(
    jsonencode(each.value.settings),
    null
  )
  protected_settings = try(
    jsonencode(each.value.protected_settings),
    null
  )
}