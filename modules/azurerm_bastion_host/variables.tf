variable "config" {
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = optional(string)
    tags                = optional(map(string), {})

    ip_configuration = object({
      name                 = string
      subnet_id            = string
      public_ip_address_id = string
    })
  })
}
