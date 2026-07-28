variable "config" {
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    tags                = optional(map(string), {})

    sku = object({
      name     = string
      tier     = string
      capacity = optional(number, 2)
    })

    gateway_ip_configurations = list(object({
      name      = string
      subnet_id = string
    }))

    frontend_ports = list(object({
      name = string
      port = number
    }))

    frontend_ip_configurations = list(object({
      name                          = string
      public_ip_address_id          = optional(string)
      private_ip_address            = optional(string)
      private_ip_address_allocation = optional(string)
      subnet_id                     = optional(string)
    }))

    backend_address_pools = list(object({
      name         = string
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
      name                           = string
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
      host_name                      = optional(string)
    }))

    request_routing_rules = list(object({
      name                       = string
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = optional(string)
      backend_http_settings_name = optional(string)
      priority                   = optional(number, 100)
    }))
  })
}
