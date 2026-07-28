# Azure Generic Terraform Modules

A collection of reusable, production-ready Terraform modules for deploying Azure infrastructure following Infrastructure as Code (IaC) best practices.

The objective of this repository is to provide modular, configurable, and reusable Azure resources that can be consumed across multiple environments such as Development, Test, UAT, and Production.

---

## Features

- Reusable child modules
- Environment-specific deployment examples
- Consistent naming conventions
- Parameterized resources
- Dynamic blocks for optional configurations
- Terraform best practices
- Azure Landing Zone friendly
- Easy to extend and maintain

---

## Repository Structure

```
.
├── modules/
│   ├── azurerm_application_gateway/
│   ├── azurerm_bastion_host/
│   ├── azurerm_key_vault/
│   ├── azurerm_linux_virtual_machine/
│   ├── azurerm_network_interface/
│   ├── azurerm_nsg/
│   ├── azurerm_nsg_association/
│   ├── azurerm_public_ip/
│   ├── azurerm_resource_group/
│   ├── azurerm_subnet/
│   └── azurerm_virtual_network/
│
└── environments/
    ├── dev/
    └── prod/
```

---

## Available Modules

| Module | Purpose |
|---------|---------|
| Resource Group | Creates Azure Resource Groups |
| Virtual Network | Creates VNets |
| Subnet | Creates Subnets |
| Public IP | Creates Public IP Addresses |
| Network Interface | Creates NICs |
| NSG | Creates Network Security Groups |
| NSG Association | Associates NSGs with Subnets or NICs |
| Linux Virtual Machine | Creates Azure Linux Virtual Machines |
| Bastion Host | Creates Azure Bastion |
| Key Vault | Creates Azure Key Vault |
| Application Gateway | Creates Azure Application Gateway |

---

## Prerequisites

- Terraform >= 1.5
- Azure CLI
- Azure Subscription
- Contributor permissions on the subscription

---

## Getting Started

### Clone the repository

```bash
git clone https://github.com/<username>/azure-resources-generic-modules-terraform.git

cd azure-resources-generic-modules-terraform
```

### Authenticate

```bash
az login
```

### Initialize Terraform

```bash
terraform init
```

### Validate

```bash
terraform validate
```

### Plan

```bash
terraform plan
```

### Deploy

```bash
terraform apply
```

---

## Example Module Usage

```hcl
module "resource_group" {
  source = "../../modules/azurerm_resource_group"

  name     = "rg-demo-dev"
  location = "Central India"

  tags = {
    Environment = "Dev"
  }
}
```

---

## Design Principles

This repository follows the following principles:

- Child modules should remain generic.
- No hardcoded values.
- Inputs should be configurable.
- Optional arguments should use dynamic blocks where applicable.
- Support multiple environments.
- Minimize code duplication.
- Keep modules independent and reusable.

---

## Current Modules

- Resource Group
- Virtual Network
- Subnet
- Network Security Group
- NSG Association
- Public IP
- Network Interface
- Linux Virtual Machine
- Bastion Host
- Key Vault
- Application Gateway

---

## Future Enhancements

- Windows Virtual Machine
- Azure Firewall
- NAT Gateway
- Route Tables
- Load Balancer
- Azure Kubernetes Service (AKS)
- Virtual Machine Scale Sets
- Azure SQL Database
- Azure Container Registry
- Storage Account
- Private Endpoints
- Monitoring Modules
- Diagnostic Settings

---

## Best Practices

- Remote State
- State Locking
- Variable Validation
- Naming Standards
- Modular Architecture
- Dynamic Blocks
- Implicit Dependencies
- Tagging Strategy
- Least Privilege Access

---

## Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push the branch.
5. Open a Pull Request.

---

## License

This project is licensed under the MIT License.

---

## Author

**Sanjeev Singh**

Azure DevOps Engineer

Terraform | Azure | GitHub Actions | Kubernetes | Infrastructure as Code