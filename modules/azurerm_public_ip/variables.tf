variable "config" {
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    allocation_method   = string
    tags                = optional(map(string), {})
  })
}
