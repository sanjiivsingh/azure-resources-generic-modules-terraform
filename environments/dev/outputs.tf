# output "resource_groups" {
#   value = { for k, v in module.resource_group : k => v.resource_group }
# }

# output "virtual_networks" {
#   value = { for k, v in module.virtual_network : k => v.virtual_network }
# }

# output "subnets" {
#   value = { for k, v in module.subnet : k => v.subnet }
# }

# output "public_ips" {
#   value = { for k, v in module.public_ip : k => v.public_ip }
# }

# output "network_security_groups" {
#   value = { for k, v in module.nsg : k => v.network_security_group }
# }

# output "network_interfaces" {
#   value = { for k, v in module.network_interface : k => v.network_interface }
# }

# output "bastion_hosts" {
#   value = { for k, v in module.bastion_host : k => v.bastion_host }
# }

# output "linux_virtual_machines" {
#   value     = { for k, v in module.linux_virtual_machine : k => v.linux_virtual_machine }
#   sensitive = true
# }

# # output "application_gateways" {
# #   value = { for k, v in module.application_gateway : k => v.application_gateway }
# # }
