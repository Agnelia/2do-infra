# ==============================================================================
# INPUT VARIABLES
# ==============================================================================
# These variables allow you to customize the infrastructure without editing code
# Usage: Set values in terraform.tfvars file or via command line
# Cost Impact: Marked clearly for each variable below

# ------------------------------------------------------------------------------
# Resource Group Name
# ------------------------------------------------------------------------------
# Purpose: Names the Azure Resource Group that contains all resources
# Example: "rg-2doHealth-app" creates a resource group visible in Azure portal
# Cost: FREE - Resource groups have no cost
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-2doHealth-app"
}

# ------------------------------------------------------------------------------
# Azure Region / Location
# ------------------------------------------------------------------------------
# Purpose: Specifies which Azure data center region to deploy resources
# Common Options: "East US 2", "West US", "West Europe", "Southeast Asia"
# Note: Some regions may have different pricing, but free tier is free everywhere
# Cost: FREE tier resources are free in all regions
variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "West Europe"
}

# ------------------------------------------------------------------------------
# Static Web App Name
# ------------------------------------------------------------------------------
# Purpose: Names your Static Web App (must be globally unique in Azure)
# Format: Use lowercase letters, numbers, and hyphens only
# This name appears in your default URL: https://<name>.azurestaticapps.net
# Cost: FREE - when using Free SKU tier
variable "static_web_app_name" {
  description = "Name of the Azure Static Web App"
  type        = string
  default     = "swa-2doHealth-app"
}

# ------------------------------------------------------------------------------
# SKU Tier (Pricing Tier)
# ------------------------------------------------------------------------------
# Purpose: Determines the pricing and feature tier for Static Web App
# Options:
#   - "Free": NO COST - 100GB bandwidth, 0.5GB storage, custom domains, SSL
#   - "Standard": PAID - Higher limits, SLA, staging environments
# 
# IMPORTANT: Keep this as "Free" to avoid any Azure charges
# Cost: FREE when set to "Free", PAID when set to "Standard"
variable "sku_tier" {
  description = "SKU tier for Static Web App (Free or Standard)"
  type        = string
  default     = "Free"
}

# ------------------------------------------------------------------------------
# SKU Size (Must Match SKU Tier)
# ------------------------------------------------------------------------------
# Purpose: Size parameter that must match the sku_tier
# Valid combinations:
#   - sku_tier = "Free" requires sku_size = "Free"
#   - sku_tier = "Standard" requires sku_size = "Standard"
#
# IMPORTANT: Keep this as "Free" to avoid any Azure charges
# Cost: FREE when set to "Free", PAID when set to "Standard"
variable "sku_size" {
  description = "SKU size for Static Web App (Free or Standard)"
  type        = string
  default     = "Free"
}

# ------------------------------------------------------------------------------
# Resource Tags
# ------------------------------------------------------------------------------
# Purpose: Adds metadata labels to Azure resources for organization
# Benefits:
#   - Organize resources in Azure portal
#   - Track costs by environment or application
#   - Identify who manages each resource
#   - Search and filter resources
# Cost: FREE - Tags have no cost, purely organizational
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production" # Which environment (Production, Development, etc.)
    Application = "2doHealth"  # Application name
    ManagedBy   = "Terraform"  # How the resource is managed
  }
}
