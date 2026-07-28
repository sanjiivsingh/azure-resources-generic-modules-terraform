variable "environment" {
  type        = string
  description = "Environment identifier (e.g. dev, prod)"
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "Project name prefix for resources"
  default     = "corp"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "Central India"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default     = {}
}

variable "resource_groups" {
  type = map(object({
    name_suffix = string
  }))
}

variable "virtual_networks" {
  type = map(object({
    name_suffix   = string
    rg_key        = string
    address_space = list(string)
  }))
}

variable "subnets" {
  type = map(object({
    name             = string
    rg_key           = string
    vnet_key         = string
    address_prefixes = list(string)
  }))
}

variable "public_ips" {
  type = map(object({
    name_suffix       = string
    rg_key            = string
    allocation_method = string
    sku               = optional(string)
  }))
}

variable "nsgs" {
  type = map(object({
    name_suffix = string
    rg_key      = string
    security_rules = optional(map(object({
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), {})
  }))
}

variable "nsg_associations" {
  type = map(object({
    subnet_key = string
    nsg_key    = string
  }))
}

variable "network_interfaces" {
  type = map(object({
    name_suffix                   = string
    rg_key                        = string
    subnet_key                    = string
    ip_config_name                = string
    private_ip_address_allocation = string
    private_ip_address            = optional(string)
  }))
}

variable "bastion_hosts" {
  type = map(object({
    name_suffix = string
    rg_key      = string
    subnet_key  = string
    pip_key     = string
    sku         = optional(string)
  }))
}

variable "linux_vms" {
  type = map(object({
    name_suffix    = string
    rg_key         = string
    nic_key        = string
    size           = string
    admin_username = string
    admin_ssh_key  = optional(string)
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
  }))
}

variable "application_gateways" {
  type = map(object({
    name_suffix = string
    rg_key      = string
    sku = object({
      name     = string
      tier     = string
      capacity = optional(number, 2)
    })
    subnet_key = string
    pip_key    = string
    frontend_ports = list(object({
      name = string
      port = number
    }))
    backend_address_pools = list(object({
      name         = string
      nic_keys     = optional(list(string))
      ip_addresses = optional(list(string))
      fqdns        = optional(list(string))
    }))
    backend_http_settings = list(object({
      name                  = string
      cookie_based_affinity = string
      port                  = number
      protocol              = string
      request_timeout       = number
    }))
    http_listeners = list(object({
      name               = string
      frontend_port_name = string
      protocol           = string
      host_name          = optional(string)
    }))
    request_routing_rules = list(object({
      name                       = string
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = optional(string)
      backend_http_settings_name = optional(string)
      priority                   = optional(number, 100)
    }))
  }))
  default = {}
}

variable "key_vaults" {
  type = map(object(
    {
      name_suffix                 = string
      rg_key                      = string
      rbac_authorization_enabled  = bool
      enabled_for_disk_encryption = bool
      soft_delete_retention_days  = number
      purge_protection_enabled    = bool

      sku_name = string

      access_policy = optional(map(object({
        key_permissions     = list(string)
        secret_permissions  = list(string)
        storage_permissions = list(string)
        }
      )), {})
    })
  )
}
