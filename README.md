# 2do-infra

Infrastructure as Code (IaC) for the 2do application using Terraform and Azure.

## Overview

This repository contains Terraform configurations to deploy a 2do application infrastructure on Azure. The setup includes:

- **Azure Static Web App**: Hosts the static frontend with built-in support for serverless functions (Azure Functions) as the backend
- **Resource Group**: Logical container for all Azure resources

## Architecture

The Azure Static Web App provides:
- Static content hosting for the frontend application
- Built-in Azure Functions for serverless backend APIs
- Automatic HTTPS
- Custom domain support
- Global distribution via CDN
- Authentication and authorization

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- An active Azure subscription

## Setup

### 1. Azure Authentication

Login to Azure using the Azure CLI:

```bash
az login
```

Set your subscription (if you have multiple):

```bash
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### 2. Configure Variables

Copy the example variables file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` to set your desired configuration:

```hcl
resource_group_name  = "rg-2do-app"
location             = "East US 2"
static_web_app_name  = "swa-2do-app"
sku_tier             = "Free"
sku_size             = "Free"
```

### 3. Deploy Infrastructure

Initialize Terraform:

```bash
terraform init
```

Review the planned changes:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

## Deploying Your Application

After the infrastructure is created, you can deploy your application to the Static Web App:

1. Get the deployment token:
   ```bash
   terraform output -raw static_web_app_api_key
   ```

2. Use the [Azure Static Web Apps CLI](https://azure.github.io/static-web-apps-cli/) or GitHub Actions to deploy your app

3. Your app will be available at the URL shown in:
   ```bash
   terraform output static_web_app_default_host_name
   ```

## Serverless Functions

Azure Static Web Apps includes built-in support for Azure Functions. To add serverless functions:

1. Create an `api` folder in your application repository
2. Add your Azure Functions to the `api` folder
3. Functions are automatically deployed with your static content

Example structure:
```
your-app/
├── public/          # Static web content
│   └── index.html
└── api/             # Serverless functions
    └── function1/
        ├── function.json
        └── index.js
```

## Outputs

After deployment, the following outputs are available:

- `resource_group_name`: Name of the resource group
- `static_web_app_name`: Name of the Static Web App
- `static_web_app_default_host_name`: Default URL of your application
- `static_web_app_api_key`: Deployment token (sensitive)

View all outputs:
```bash
terraform output
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted to confirm.

## File Structure

```
.
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── terraform.tfvars.example   # Example variables file
├── .gitignore                 # Git ignore rules for Terraform
└── README.md                  # This file
```

## Customization

### SKU Options

The Static Web App supports two SKU tiers:

- **Free**: Limited features, suitable for development
- **Standard**: Full features including custom authentication, increased bandwidth

To use Standard tier, update your `terraform.tfvars`:

```hcl
sku_tier = "Standard"
sku_size = "Standard"
```

### Location

Available Azure regions can be listed with:

```bash
az account list-locations -o table
```

### Tags

Tags help organize and track Azure resources. Customize them in `terraform.tfvars`:

```hcl
tags = {
  Environment = "Production"
  Application = "2do"
  ManagedBy   = "Terraform"
  Owner       = "YourName"
}
```

## Contributing

When making changes to the infrastructure:

1. Create a feature branch
2. Make your changes
3. Run `terraform fmt` to format the code
4. Run `terraform validate` to validate the configuration
5. Test with `terraform plan`
6. Submit a pull request

## Resources

- [Azure Static Web Apps Documentation](https://docs.microsoft.com/en-us/azure/static-web-apps/)
- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Static Web Apps Pricing](https://azure.microsoft.com/en-us/pricing/details/app-service/static/)