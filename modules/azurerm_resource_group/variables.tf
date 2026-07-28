variable "config" {
  type = object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  })
}