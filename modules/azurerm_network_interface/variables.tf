variable "config" {
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    tags                = optional(map(string), {})

    ip_configurations = list(object({
      name                          = string
      subnet_id                     = string
      private_ip_address_allocation = string
      private_ip_address            = optional(string)
    }))
  })
}
