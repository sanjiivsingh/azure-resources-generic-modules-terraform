locals {

  # Common tags for child module
  common_tags = merge({
    Project     = var.project_name
    Environment = var.environment
  }, var.tags)

  # Name prefix for child module resources
  name_prefix = "${var.project_name}-${var.environment}"

  # name_prefix = join("-", [
  #   var.project_name,
  #   var.environment
  # ])

  # Resource Group objects for child module
  resource_groups = {
    for k, v in var.resource_groups : k => {
      name     = "rg-${local.name_prefix}-${v.name_suffix}"
      location = var.location
      tags     = local.common_tags
    }
  }

  # Virtual Network objects for child module
  virtual_networks = {
    for k, v in var.virtual_networks : k => {
      name                = "vnet-${local.name_prefix}-${v.name_suffix}"
      location            = var.location
      resource_group_name = module.resource_group[v.rg_key].resource_group.name
      address_space       = v.address_space
      tags                = local.common_tags
    }
  }

  # Subnet objects for child module
  subnets = {
    for k, v in var.subnets : k => {
      name                 = v.name
      resource_group_name  = module.resource_group[v.rg_key].resource_group.name
      virtual_network_name = module.virtual_network[v.vnet_key].virtual_network.name
      address_prefixes     = v.address_prefixes
    }
  }

  # Public IP objects for child module
  public_ips = {
    for k, v in var.public_ips : k => {
      name                = "pip-${local.name_prefix}-${v.name_suffix}"
      resource_group_name = module.resource_group[v.rg_key].resource_group.name
      location            = var.location
      allocation_method   = v.allocation_method
      sku                 = v.sku
      tags                = local.common_tags
    }
  }

  # NSG objects for child module
  nsgs = {
    for k, v in var.nsgs : k => {
      name                = "nsg-${local.name_prefix}-${v.name_suffix}"
      location            = var.location
      resource_group_name = module.resource_group[v.rg_key].resource_group.name
      security_rule       = v.security_rules
      tags                = local.common_tags
    }
  }

  # NSG Association objects for child module
  nsg_associations = {
    for k, v in var.nsg_associations : k => {
      subnet_id                 = module.subnet[v.subnet_key].subnet.id
      network_security_group_id = module.nsg[v.nsg_key].network_security_group.id
    }
  }

  # Network Interface objects for child module
  network_interfaces = {
    for k, v in var.network_interfaces : k => {
      name                = "nic-${local.name_prefix}-${v.name_suffix}"
      location            = var.location
      resource_group_name = module.resource_group[v.rg_key].resource_group.name
      tags                = local.common_tags
      ip_configurations = [
        {
          name                          = v.ip_config_name
          subnet_id                     = module.subnet[v.subnet_key].subnet.id
          private_ip_address_allocation = v.private_ip_address_allocation
          private_ip_address            = v.private_ip_address
        }
      ]
    }
  }

  # Bastion Host objects for child module
  bastion_hosts = {
    for k, v in var.bastion_hosts : k => {
      name                = "bas-${local.name_prefix}-${v.name_suffix}"
      location            = var.location
      resource_group_name = module.resource_group[v.rg_key].resource_group.name
      sku                 = v.sku
      tags                = local.common_tags
      ip_configuration = {
        name                 = "bastion-ip-config"
        subnet_id            = module.subnet[v.subnet_key].subnet.id
        public_ip_address_id = module.public_ip[v.pip_key].public_ip.id
      }
    }
  }

  # Linux Virtual Machine objects for child module
  virtual_machines = {
    for k, v in var.virtual_machines : k =>
    {
      name                   = "vm-${local.name_prefix}-${v.name_suffix}"
      resource_group_name    = module.resource_group[v.rg_key].resource_group.name
      location               = var.location
      size                   = v.size
      network_interface_ids  = [module.network_interface[v.nic_key].network_interface.id, ]
      os_disk                = v.os_disk
      source_image_reference = v.source_image_reference
      authentication = {
        type             = v.authentication.type
        admin_username   = data.azurerm_key_vault_secret.username.value
        admin_password   = data.azurerm_key_vault_secret.password.value
        admin_public_key = data.azurerm_key_vault_secret.public_key.value
      }

      extensions = v.authentication.type == "entra" ? {
        for key, value in v.extensions : key =>
        {
          publisher                  = value.publisher
          type                       = value.type
          type_handler_version       = value.type_handler_version
          auto_upgrade_minor_version = value.auto_upgrade_minor_version
        }

      } : {}
    }
  }

  # Application Gateway objects for child module
  application_gateways = {
    for k, v in var.application_gateways : k => {
      name                = "agw-${local.name_prefix}-${v.name_suffix}"
      location            = var.location
      resource_group_name = module.resource_group[v.rg_key].resource_group.name
      sku                 = v.sku
      tags                = local.common_tags
      gateway_ip_configurations = [
        {
          name      = "appgw-ip-config"
          subnet_id = module.subnet[v.subnet_key].subnet.id
        }
      ]
      frontend_ip_configurations = [
        {
          name                 = "appgw-frontend-ip"
          public_ip_address_id = module.public_ip[v.pip_key].public_ip.id
        }
      ]
      frontend_ports = v.frontend_ports
      backend_address_pools = [
        for pool in v.backend_address_pools : {
          name = pool.name
          ip_addresses = pool.nic_keys != null ? [
            for nk in pool.nic_keys : module.network_interface[nk].network_interface.private_ip_address
          ] : pool.ip_addresses
          fqdns = pool.fqdns
        }
      ]
      backend_http_settings = v.backend_http_settings
      http_listeners = [
        for l in v.http_listeners : {
          name                           = l.name
          frontend_ip_configuration_name = "appgw-frontend-ip"
          frontend_port_name             = l.frontend_port_name
          protocol                       = l.protocol
          host_name                      = l.host_name
        }
      ]
      request_routing_rules = v.request_routing_rules
    }
  }

  # Key Vault objects for child module
  key_vaults = {
    for k, v in var.key_vaults : k => {
      name                        = "kv-${local.name_prefix}-${v.name_suffix}"
      location                    = var.location
      resource_group_name         = module.resource_group[v.rg_key].resource_group.name
      rbac_authorization_enabled  = v.rbac_authorization_enabled
      enabled_for_disk_encryption = v.enabled_for_disk_encryption
      tenant_id                   = data.azurerm_client_config.current.tenant_id
      soft_delete_retention_days  = v.soft_delete_retention_days
      purge_protection_enabled    = v.purge_protection_enabled

      sku_name = v.sku_name

      access_policy = {
        for policy_name, policy in v.access_policy : policy_name =>
        merge(
          policy,
          {
            tenant_id = data.azurerm_client_config.current.tenant_id
            object_id = data.azurerm_client_config.current.object_id
        })
      }
    }
  }
}



