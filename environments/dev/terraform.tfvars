environment  = "dev"
project_name = "oneps"
location     = "Central India"

tags = {
  Managed_By = "Terraform"
  Owner      = "DevOpsTeam"
}

# 1 Resource Group
resource_groups = {
  "main" = {
    name_suffix = "01"
  }
}

# 2 Virtual Network
virtual_networks = {
  "main_vnet" = {
    name_suffix   = "01"
    rg_key        = "main"
    address_space = ["10.0.0.0/16"]
  }
}

# 3 Subnets (Frontend, Backend, Bastion, Application Gateway)
subnets = {
  "frontend" = {
    name             = "snet-frontend"
    rg_key           = "main"
    vnet_key         = "main_vnet"
    address_prefixes = ["10.0.1.0/24"]
  }
  "backend" = {
    name             = "snet-backend"
    rg_key           = "main"
    vnet_key         = "main_vnet"
    address_prefixes = ["10.0.2.0/24"]
  }
  "bastion" = {
    name             = "AzureBastionSubnet"
    rg_key           = "main"
    vnet_key         = "main_vnet"
    address_prefixes = ["10.0.3.0/24"]
  }
  "appgw" = {
    name             = "snet-appgateway"
    rg_key           = "main"
    vnet_key         = "main_vnet"
    address_prefixes = ["10.0.4.0/24"]
  }
}

# 4 Public IPs (1 for Bastion, 1 for Application Gateway)
public_ips = {
  "bastion_pip" = {
    name_suffix       = "bastion"
    rg_key            = "main"
    allocation_method = "Static"
    sku               = "Standard"
  }
  "appgw_pip" = {
    name_suffix       = "appgw"
    rg_key            = "main"
    allocation_method = "Static"
    sku               = "Standard"
  }
}

# 5 Supporting Security Groups
nsgs = {
  "frontend_nsg" = {
    name_suffix = "frontend"
    rg_key      = "main"
    security_rules = {
      "allow_ssh" = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
      "allow_http" = {
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
  }
  "backend_nsg" = {
    name_suffix = "backend"
    rg_key      = "main"
    security_rules = {
      "allow_ssh" = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
      "allow_http" = {
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
  }
}

nsg_associations = {
  "frontend_assoc" = {
    subnet_key = "frontend"
    nsg_key    = "frontend_nsg"
  }
  "backend_assoc" = {
    subnet_key = "backend"
    nsg_key    = "backend_nsg"
  }
}

# 7 Network Interfaces (for Frontend VM & Backend VM)
network_interfaces = {
  "frontend_nic" = {
    name_suffix                   = "frontend-01"
    rg_key                        = "main"
    subnet_key                    = "frontend"
    ip_config_name                = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
  }
  "backend_nic" = {
    name_suffix                   = "backend-01"
    rg_key                        = "main"
    subnet_key                    = "backend"
    ip_config_name                = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
  }
}

# 8 Bastion Host
bastion_hosts = {
  "main_bastion" = {
    name_suffix = "01"
    rg_key      = "main"
    subnet_key  = "bastion"
    pip_key     = "bastion_pip"
    sku         = "Standard"
  }
}

# 9 Linux Virtual Machines (Frontend VM & Backend VM)
linux_vms = {
  "frontend_vm" = {
    name_suffix = "fe-01"
    rg_key      = "main"
    nic_key     = "frontend_nic"
    size        = "Standard_D2s_v3"
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  }
  "backend_vm" = {
    name_suffix = "be-01"
    rg_key      = "main"
    nic_key     = "backend_nic"
    size        = "Standard_D2s_v3"
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  }
}

# 10 Application Gateway (Domain-based routing for front.b18g4.online & back.b18g4.online)
application_gateways = {
  "main_appgw" = {
    name_suffix = "01"
    rg_key      = "main"
    subnet_key  = "appgw"
    pip_key     = "appgw_pip"

    sku = {
      name     = "Standard_v2"
      tier     = "Standard_v2"
      capacity = 2
    }

    frontend_ports = [
      {
        name = "http-port"
        port = 80
      }
    ]

    backend_address_pools = [
      {
        name     = "frontend-pool"
        nic_keys = ["frontend_nic"]
      },
      {
        name     = "backend-pool"
        nic_keys = ["backend_nic"]
      }
    ]

    backend_http_settings = [
      {
        name                  = "http-setting"
        cookie_based_affinity = "Disabled"
        port                  = 80
        protocol              = "Http"
        request_timeout       = 30
      }
    ]

    http_listeners = [
      {
        name               = "frontend-listener"
        frontend_port_name = "http-port"
        protocol           = "Http"
        host_name          = "front.b18g4.online"
      },
      {
        name               = "backend-listener"
        frontend_port_name = "http-port"
        protocol           = "Http"
        host_name          = "back.b18g4.online"
      }
    ]

    request_routing_rules = [
      {
        name                       = "rule-frontend"
        rule_type                  = "Basic"
        http_listener_name         = "frontend-listener"
        backend_address_pool_name  = "frontend-pool"
        backend_http_settings_name = "http-setting"
        priority                   = 100
      },
      {
        name                       = "rule-backend"
        rule_type                  = "Basic"
        http_listener_name         = "backend-listener"
        backend_address_pool_name  = "backend-pool"
        backend_http_settings_name = "http-setting"
        priority                   = 200
      }
    ]
  }
}

# 11 Key Vaults
key_vaults = {
  "main_kv" = {
    name_suffix                 = "01"
    rg_key                      = "main"
    rbac_authorization_enabled  = false
    enabled_for_disk_encryption = true
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false

    sku_name = "standard"

    access_policy = {
      admin = {
        key_permissions     = ["Get"]
        secret_permissions  = ["Get"]
        storage_permissions = ["Get"]
      }
    }


  }
}

