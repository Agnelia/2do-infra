# ==============================================================================
# TERRAFORM CONFIGURATION
# ==============================================================================
# This block defines the Terraform version and required providers.
# Purpose: Ensures consistent Terraform behavior across different environments
# Cost: Free - Configuration only, no Azure resources created here

terraform {
  # Minimum Terraform version required to run this configuration
  # Using 1.0 or higher ensures access to modern Terraform features
  required_version = ">= 1.0"
  
  # Azure Resource Manager (azurerm) provider configuration
  # This provider enables Terraform to interact with Azure services
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"  # Official Azure provider from HashiCorp
      version = "~> 3.0"              # Use any 3.x version (allows minor updates)
    }
  }
}

# ==============================================================================
# AZURE PROVIDER
# ==============================================================================
# Configures authentication and features for the Azure provider
# Purpose: Establishes connection to Azure using credentials from environment
# Authentication: Uses Azure CLI credentials or environment variables
# Cost: Free - No charges for provider configuration

provider "azurerm" {
  # Features block is required even if empty - enables provider functionality
  features {}
}

# ==============================================================================
# RESOURCE GROUP
# ==============================================================================
# Creates a logical container for all Azure resources in this project
# Purpose: Organizes and manages related Azure resources together
# Benefits: Simplifies management, billing tracking, and bulk operations
# Cost: FREE - Resource groups themselves have no cost in Azure

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name  # Name from variables (default: "rg-2doHealth-app")
  location = var.location              # Azure region (default: "North Europe")
  
  # Tags help organize and track resources in Azure portal and billing
  tags = var.tags
}

# ==============================================================================
# AZURE STATIC WEB APP
# ==============================================================================
# Creates a Static Web App for hosting static content and serverless APIs
# Purpose: 
#   - Hosts your frontend (HTML, CSS, JavaScript, React, Vue, etc.)
#   - Provides built-in Azure Functions for serverless backend APIs
#   - Includes automatic HTTPS, CDN, and global distribution
# 
# Serverless Functions:
#   - Add an "api" folder to your app repository
#   - Azure Functions are automatically deployed with your static content
#   - No additional Azure resources needed for backend APIs
#
# Cost: FREE tier includes:
#   - 100 GB bandwidth per month
#   - 0.5 GB storage
#   - Custom domains
#   - Automatic SSL/HTTPS
#   - Built-in authentication
#   - Azure Functions (serverless backend)
#
# Note: Free tier has NO COST - perfect for development and small projects

resource "azurerm_static_web_app" "main" {
  name                = var.static_web_app_name           # Name from variables
  resource_group_name = azurerm_resource_group.main.name  # Links to resource group
  location            = azurerm_resource_group.main.location  # Same region as RG
  
  # SKU (pricing tier) configuration - using FREE tier to avoid costs
  sku_tier            = var.sku_tier  # "Free" = no cost, "Standard" = paid
  sku_size            = var.sku_size  # "Free" = no cost, "Standard" = paid
  
  # Tags for resource organization and tracking
  tags = var.tags
}
