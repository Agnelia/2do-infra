# 2do-infra

Infrastructure as Code (IaC) for the 2do application using Terraform and Azure.

> **💰 COST: 100% FREE** - All resources use Azure's free tier. No credit card charges!

## Overview

This repository contains Terraform configurations to deploy a 2do application infrastructure on Azure using **GitHub Actions for automation**. Everything is configured to use **free tier resources only** - no Azure costs!

### What's Included

- **Azure Static Web App (Free Tier)**: Hosts the static frontend with built-in support for serverless functions (Azure Functions) as the backend
- **Resource Group**: Logical container for all Azure resources
- **GitHub Actions Workflow**: Automated deployment (no manual Terraform commands needed)

### Free Tier Benefits

The Azure Static Web App Free tier includes:
- ✅ 100 GB bandwidth per month
- ✅ 0.5 GB storage
- ✅ Custom domains
- ✅ Automatic HTTPS/SSL
- ✅ Built-in Azure Functions (serverless backend)
- ✅ Global CDN distribution
- ✅ **$0.00/month cost**

---

## Quick Start with GitHub Actions (Recommended)

**This is the easiest way to deploy - no local Terraform installation needed!**

### Prerequisites

1. **Azure Account** (free tier) - [Sign up here](https://azure.microsoft.com/free/)
2. **GitHub Account** 

### Setup (One-Time)

1. **Fork/Clone this repository**

2. **Create Azure Service Principal** (gives GitHub Actions permission to deploy):
   ```bash
   az login
   az ad sp create-for-rbac \
     --name "github-actions-2do-infra" \
     --role contributor \
     --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
     --sdk-auth
   ```

3. **Add GitHub Secrets** (Settings → Secrets → Actions):
   - `AZURE_CLIENT_ID`
   - `AZURE_CLIENT_SECRET`
   - `AZURE_SUBSCRIPTION_ID`
   - `AZURE_TENANT_ID`
   
   (Use values from the Service Principal output above)

4. **Push to main branch**:
   ```bash
   git push origin main
   ```

5. **Done!** GitHub Actions automatically deploys your infrastructure. Check the Actions tab to see progress.

📖 **Detailed step-by-step guide**: See [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md) for complete instructions with screenshots and troubleshooting.

---

## Manual Deployment (Alternative)

If you prefer to run Terraform locally instead of using GitHub Actions:

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- An active Azure subscription (free tier)

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
├── .github/
│   └── workflows/
│       └── terraform-deploy.yml    # GitHub Actions workflow for automated deployment
├── main.tf                          # Main Terraform configuration (resources)
├── variables.tf                     # Variable definitions (configuration options)
├── outputs.tf                       # Output definitions (URLs, IDs, keys)
├── terraform.tfvars.example         # Example variables file
├── .gitignore                       # Git ignore rules for Terraform
├── README.md                        # This file
└── GITHUB_ACTIONS_SETUP.md          # Detailed GitHub Actions setup guide
```

## What Each File Does

### Configuration Files

| File | Purpose | What It Contains | Need to Edit? |
|------|---------|------------------|---------------|
| **main.tf** | Core infrastructure definition | Defines Azure resources (Resource Group, Static Web App). Includes detailed comments explaining each resource and configuration. | ❌ No (uses FREE tier by default) |
| **variables.tf** | Configurable parameters | Defines customizable settings like resource names, Azure region, SKU tier. Each variable has detailed comments explaining its purpose and cost impact. | ✅ Yes (optional, to customize names/region) |
| **outputs.tf** | Export important values | Exports URLs, IDs, and API keys after deployment. Comments explain what each output is for and how to use it. | ❌ No |
| **terraform.tfvars.example** | Example configuration | Shows sample values for all variables with detailed comments on usage and cost. | 📋 Copy to `terraform.tfvars` for local use |

### GitHub Actions

| File | Purpose | What It Contains | Need to Edit? |
|------|---------|------------------|---------------|
| **.github/workflows/terraform-deploy.yml** | Automated deployment workflow | GitHub Actions workflow that automatically deploys infrastructure when you push to main branch. Every step has detailed comments. | ❌ No (works out of the box) |
| **GITHUB_ACTIONS_SETUP.md** | Setup instructions | Complete step-by-step guide for configuring GitHub Actions, including Azure Service Principal creation, GitHub Secrets setup, and troubleshooting. | 📖 Read this for setup |

### Other Files

| File | Purpose |
|------|---------|
| **.gitignore** | Prevents committing sensitive Terraform files (state, variables with secrets) |
| **README.md** | Main documentation (this file) |

## Understanding the Terraform Files

### main.tf - Infrastructure Definition

This file creates your Azure resources. It includes:

1. **Terraform Configuration Block**
   - Specifies Terraform version requirement
   - Configures Azure provider
   - **Cost**: FREE (configuration only)

2. **Azure Provider Block**
   - Sets up authentication with Azure
   - Uses credentials from Azure CLI or environment variables
   - **Cost**: FREE

3. **Resource Group Resource**
   - Creates a logical container for all resources
   - **Cost**: FREE (resource groups have no cost)

4. **Static Web App Resource**
   - Creates the main hosting infrastructure
   - Includes built-in Azure Functions for backend
   - **Cost**: FREE (when using Free SKU tier)

**All resources are heavily commented** - open the file to see detailed explanations of every line.

### variables.tf - Configuration Options

Defines parameters you can customize:

- `resource_group_name` - Name of the resource group (default: "rg-2do-app")
- `location` - Azure region (default: "East US 2")  
- `static_web_app_name` - Name of your app (default: "swa-2do-app")
- `sku_tier` - Pricing tier (default: "Free" - **DO NOT CHANGE to avoid costs**)
- `sku_size` - SKU size (default: "Free" - **DO NOT CHANGE to avoid costs**)
- `tags` - Resource labels for organization

**Each variable includes**:
- Description of what it does
- Default value (safe defaults that are FREE)
- Cost information
- Usage examples in comments

### outputs.tf - Exported Values

After deployment, Terraform exports:

- `resource_group_name` - Name of created resource group
- `resource_group_id` - Azure resource ID
- `static_web_app_name` - Name of your Static Web App
- `static_web_app_id` - Azure resource ID
- `static_web_app_default_host_name` - **Your application URL**
- `static_web_app_api_key` - Deployment token (sensitive, hidden)

**Each output includes comments** explaining:
- What the value is
- How to use it
- Where it's needed

## Cost Guarantee

**All resources in this configuration use FREE tier only:**

- ✅ Resource Group: Always FREE
- ✅ Static Web App with Free SKU: Always FREE
- ✅ Built-in Azure Functions: Included FREE in Static Web App
- ✅ Bandwidth: 100GB/month FREE
- ✅ SSL/HTTPS: Included FREE
- ✅ Custom domains: Included FREE

**To ensure no costs**:
1. Don't change `sku_tier` or `sku_size` from "Free"
2. Stay within 100GB bandwidth/month (very generous for small apps)
3. Monitor usage in Azure Portal (Cost Management + Billing)

---

## Customization

### SKU Options

The Static Web App supports two SKU tiers:

- **Free**: ✅ **RECOMMENDED** - NO COST - 100GB bandwidth, 0.5GB storage, custom domains, SSL
- **Standard**: ⚠️ **PAID SERVICE** - Higher limits, SLA, staging environments, costs money

**WARNING**: Changing to Standard tier will incur Azure charges. Only change if you need paid features.

To use Standard tier (not recommended for free setup), update your `terraform.tfvars`:

```hcl
sku_tier = "Standard"  # ⚠️ This will cost money!
sku_size = "Standard"  # ⚠️ This will cost money!
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