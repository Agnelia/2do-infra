# GitHub Actions Setup Guide

## Overview

This guide explains how to set up GitHub Actions to deploy your Azure infrastructure using Terraform. The workflow is **completely free** - no costs for GitHub Actions or Azure resources.

## What This Automation Does

When you **manually trigger** the workflow from GitHub Actions, it will:

1. ✅ Authenticate with Azure
2. ✅ Initialize Terraform
3. ✅ Validate your configuration
4. ✅ Create an execution plan
5. ✅ Deploy your infrastructure to Azure (FREE tier resources)
6. ✅ Display your application URL

**Note**: The workflow runs **only when you manually trigger it** - there are no automatic deployments on push or pull requests.

## Cost Breakdown - Everything is FREE

| Component | Cost |
|-----------|------|
| GitHub Actions (public repo) | **FREE** |
| Azure Resource Group | **FREE** |
| Azure Static Web App (Free tier) | **FREE** |
| Azure Functions (included in Static Web App) | **FREE** |
| Terraform | **FREE** (open source) |
| **TOTAL COST** | **$0.00** |

The Free tier of Azure Static Web Apps includes:
- 100 GB bandwidth per month
- 0.5 GB storage
- Unlimited SSL certificates
- Custom domains
- Built-in Azure Functions (serverless backend)
- Automatic HTTPS

## Prerequisites

Before setting up GitHub Actions, you need:

1. **Azure Account** (Free tier)
   - Sign up at https://azure.microsoft.com/free/
   - No credit card required for free services
   
2. **GitHub Account**
   - Repository must be public (for free GitHub Actions)
   - Or use GitHub Free for private repos (2,000 minutes/month free)

3. **Azure CLI** installed on your local machine
   - Download from https://docs.microsoft.com/cli/azure/install-azure-cli

## Step-by-Step Setup

### Step 1: Create Azure Service Principal

A Service Principal is like a robot user that GitHub Actions uses to access your Azure account.

#### 1.1 Login to Azure CLI

```bash
az login
```

This opens your browser to authenticate.

#### 1.2 Get Your Subscription ID

```bash
az account show --query id --output tsv
```

Save this ID - you'll need it later. It looks like: `12345678-1234-1234-1234-123456789abc`

#### 1.3 Create Service Principal

Replace `YOUR_SUBSCRIPTION_ID` with the ID from step 1.2:

```bash
az ad sp create-for-rbac \
  --name "github-actions-2do-infra" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID
```

**IMPORTANT**: This command outputs JSON with credentials. **SAVE THIS OUTPUT** - you'll need it in the next step.

The output looks like:
```json
{
  "appId": "12345678-1234-1234-1234-123456789abc",
  "displayName": "github-actions-2do-infra",
  "password": "your-secret-here",
  "tenant": "12345678-1234-1234-1234-123456789abc"
}
```

### Step 2: Configure GitHub Secrets

GitHub Secrets store sensitive information securely. These credentials are encrypted and only available to your workflows.

#### 2.1 Navigate to Repository Settings

1. Go to your GitHub repository
2. Click **Settings** (top menu)
3. Click **Secrets and variables** → **Actions** (left sidebar)
4. Click **New repository secret**

#### 2.2 Add Required Secrets

Create these 4 secrets using the values from your Service Principal JSON:

| Secret Name | Value | Where to Find |
|------------|-------|---------------|
| `AZURE_CLIENT_ID` | The `appId` from JSON | Copy from Service Principal output |
| `AZURE_CLIENT_SECRET` | The `password` from JSON | Copy from Service Principal output |
| `AZURE_SUBSCRIPTION_ID` | Your subscription ID from step 1.2 | Copy from Service Principal output or step 1.2 |
| `AZURE_TENANT_ID` | The `tenant` from JSON | Copy from Service Principal output |

**For each secret:**
1. Click "New repository secret"
2. Enter the **Name** (e.g., `AZURE_CLIENT_ID`)
3. Paste the **Value** from your Service Principal JSON
4. Click "Add secret"
5. Repeat for all 4 secrets

#### 2.3 Verify Secrets

After adding all secrets, you should see:
- ✅ AZURE_CLIENT_ID
- ✅ AZURE_CLIENT_SECRET
- ✅ AZURE_SUBSCRIPTION_ID
- ✅ AZURE_TENANT_ID

### Step 3: Customize Configuration (Optional)

If you want to change resource names or settings:

#### 3.1 Edit Variables in `variables.tf`

Open `variables.tf` and modify the `default` values:

```hcl
variable "static_web_app_name" {
  description = "Name of the Azure Static Web App"
  type        = string
  default     = "swa-2doHealth-app"  # Change this to your preferred name
}
```

**What you can change:**
- `resource_group_name` - Name of the resource group
- `location` - Azure region (e.g., "West US", "West Europe")
- `static_web_app_name` - Name of your Static Web App (must be globally unique)
- `tags` - Metadata labels for your resources

**What to keep as-is (to stay FREE):**
- `sku_tier = "Free"` ⚠️ Don't change this
- `sku_size = "Free"` ⚠️ Don't change this

### Step 4: Deploy Infrastructure

#### 4.1 Trigger the Workflow Manually

Once secrets are configured, manually trigger the deployment:

1. Go to your GitHub repository
2. Click **Actions** tab (top menu)
3. Select **"Deploy Infrastructure to Azure"** from the workflows list (left sidebar)
4. Click **"Run workflow"** button (on the right)
5. Select the branch (usually `main`)
6. Click the green **"Run workflow"** button to start

#### 4.2 Monitor Deployment

1. The workflow run will appear in the list
2. Click on the workflow run to see details
3. Watch the progress in real-time as each step completes

The workflow takes about 2-3 minutes to complete.

#### 4.3 View Deployment Results

After successful deployment, the workflow shows:
- ✅ Your Static Web App URL
- ✅ Resource Group name
- ✅ All resource IDs

**Your app URL** will be in the format:
```
https://swa-2doHealth-app-abc123.azurestaticapps.net
```

### Step 5: Get Deployment API Key

To deploy your actual application code, you need the API key.

#### Option A: Using Azure CLI

```bash
# Login
az login

# Get the API key
az staticwebapp secrets list \
  --name swa-2doHealth-app \
  --resource-group rg-2doHealth-app \
  --query "properties.apiKey" \
  --output tsv
```

#### Option B: Using Terraform Locally

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/2do-infra.git
cd 2do-infra

# Login to Azure
az login

# Initialize Terraform
terraform init

# Get outputs (API key is hidden)
terraform output

# Get API key specifically
terraform output -raw static_web_app_api_key
```

#### Option C: Using Azure Portal

1. Go to https://portal.azure.com
2. Navigate to your Static Web App resource
3. Click **Manage deployment token**
4. Copy the token

### Step 6: Deploy Your Application

Once infrastructure is ready, deploy your app:

#### 6.1 Add API Token to Application Repository

In your **application repository** (not this infrastructure repo):

1. Go to Settings → Secrets and variables → Actions
2. Create new secret: `AZURE_STATIC_WEB_APPS_API_TOKEN`
3. Paste the API key from Step 5

#### 6.2 Add GitHub Actions Workflow to App Repository

Create `.github/workflows/deploy-app.yml` in your app repo:

```yaml
name: Deploy Application

on:
  push:
    branches:
      - main

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    name: Build and Deploy
    steps:
      - uses: actions/checkout@v3
      
      - name: Build And Deploy
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          action: "upload"
          app_location: "/" # Your app code location
          api_location: "api" # Your serverless functions location (optional)
          output_location: "build" # Build output location
```

## Workflow Behavior

### Manual Trigger Only
- ✅ Triggered manually from Actions tab
- ✅ Runs Terraform plan to preview changes
- ✅ Validates configuration
- ✅ Applies changes to Azure
- ✅ Displays deployment results
- 💡 Purpose: Deploy infrastructure when you're ready

**No automatic deployments** - the workflow only runs when you manually trigger it from the GitHub Actions tab.

## File Purposes Explained

### `.github/workflows/terraform-deploy.yml`
**Purpose**: GitHub Actions workflow that automates Terraform deployment  
**What it does**: Runs Terraform commands to deploy Azure infrastructure  
**When it runs**: Only when manually triggered from GitHub Actions tab  
**Cost**: FREE

### `main.tf`
**Purpose**: Defines the Azure resources to create  
**What it contains**: 
- Terraform configuration (version, providers)
- Azure provider setup (authentication)
- Resource Group definition
- Static Web App definition  
**Cost**: FREE (uses Free tier resources)

### `variables.tf`
**Purpose**: Defines configurable parameters  
**What it contains**: 
- Resource names (customizable)
- Azure region (customizable)
- SKU tier (set to Free)
- Tags (metadata)  
**Why it exists**: Allows customization without editing main.tf

### `outputs.tf`
**Purpose**: Exports important values after deployment  
**What it contains**:
- Resource IDs
- Static Web App URL
- API deployment key (sensitive)  
**Why it exists**: Makes important values accessible for use

### `terraform.tfvars.example`
**Purpose**: Example of how to customize variables  
**What it contains**: Sample configuration values  
**How to use**: Copy to `terraform.tfvars` and customize  
**Note**: Not needed for GitHub Actions (uses defaults)

### `.gitignore`
**Purpose**: Prevents committing sensitive files  
**What it ignores**:
- `terraform.tfstate` (contains sensitive data)
- `*.tfvars` (might contain secrets)
- `.terraform/` (downloaded providers)  
**Why it exists**: Protects secrets from being committed

## Troubleshooting

### Workflow Fails: "Authentication Failed"
**Problem**: GitHub can't authenticate with Azure  
**Solution**: 
1. Verify all 4 GitHub secrets are set correctly
2. Check Service Principal is still active: `az ad sp list --display-name github-actions-2do-infra`
3. Recreate Service Principal if needed (Step 1.3)

### Workflow Fails: "Resource Already Exists"
**Problem**: Resource names must be unique across Azure  
**Solution**: Change `static_web_app_name` in `variables.tf` to something unique

### Workflow Fails: "Terraform State Lock"
**Problem**: Another Terraform run is in progress  
**Solution**: Wait for previous run to complete or check Azure portal

### Can't Find API Key
**Problem**: Need deployment token for application  
**Solution**: See Step 5 above for three ways to retrieve it

### Cost Concerns
**Problem**: Worried about Azure charges  
**Solution**: 
- Verify `sku_tier = "Free"` in `variables.tf`
- Check Azure Portal → Cost Management
- Set up billing alerts in Azure (free to configure)

## Advanced: Using Remote State (Optional)

For team collaboration, store Terraform state in Azure Storage (free tier available):

### 1. Create Storage Account

```bash
# Create resource group
az group create --name rg-terraform-state --location "East US 2"

# Create storage account (use unique name)
az storage account create \
  --name tfstate2dohealth \
  --resource-group rg-terraform-state \
  --location "East US 2" \
  --sku Standard_LRS \
  --kind StorageV2

# Create container
az storage container create \
  --name tfstate \
  --account-name tfstate2dohealth
```

### 2. Update main.tf

Add backend configuration:

```hcl
terraform {
  required_version = ">= 1.0"
  
  # Add this backend block
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstate2dohealth"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
```

## Summary

After setup, your workflow is:

1. **Make infrastructure changes** → Edit `.tf` files
2. **Commit and push** → Push changes to your repository
3. **Manually trigger workflow** → Go to Actions tab, select workflow, click "Run workflow"
4. **Monitor deployment** → Watch the workflow run in real-time
5. **View results** → Check Actions tab for deployment URL

**The workflow only runs when you manually trigger it from GitHub Actions - no automatic deployments!**

## Resources

- [Azure Static Web Apps Docs](https://docs.microsoft.com/azure/static-web-apps/)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Free Services](https://azure.microsoft.com/free/)
