# ==============================================================================
# OUTPUT VALUES
# ==============================================================================
# These outputs expose important information after Terraform creates resources
# Purpose: Provides values needed for deployment, configuration, and monitoring
# Usage: Run "terraform output" to see all values, or "terraform output <name>"

# ------------------------------------------------------------------------------
# Resource Group Outputs
# ------------------------------------------------------------------------------
# These outputs provide information about the created Resource Group

# Name of the Resource Group - useful for Azure CLI commands
# Example: az resource list --resource-group <this-value>
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

# Azure Resource ID - unique identifier for the Resource Group
# Format: /subscriptions/{subscription-id}/resourceGroups/{rg-name}
# Used in Azure APIs and advanced automation
output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.main.id
}

# ------------------------------------------------------------------------------
# Static Web App Outputs
# ------------------------------------------------------------------------------
# These outputs provide critical information about your Static Web App

# Name of the Static Web App
# Used for reference and Azure CLI operations
output "static_web_app_name" {
  description = "Name of the Static Web App"
  value       = azurerm_static_web_app.main.name
}

# Azure Resource ID of the Static Web App
# Format: /subscriptions/{sub-id}/resourceGroups/{rg}/providers/Microsoft.Web/staticSites/{name}
# Used for advanced Azure operations and automation
output "static_web_app_id" {
  description = "ID of the Static Web App"
  value       = azurerm_static_web_app.main.id
}

# ------------------------------------------------------------------------------
# Static Web App URL
# ------------------------------------------------------------------------------
# This is the public URL where your application will be accessible
# Format: https://<app-name>.<random-id>.azurestaticapps.net
# Purpose: Your application's default domain (you can add custom domains later)
# 
# IMPORTANT: Use this URL to access your deployed application
# Save this value - you'll need it to test your app after deployment
output "static_web_app_default_host_name" {
  description = "Default hostname of the Static Web App"
  value       = azurerm_static_web_app.main.default_host_name
}

# ------------------------------------------------------------------------------
# Deployment API Key (SENSITIVE)
# ------------------------------------------------------------------------------
# This is the secret token used to deploy your application to Azure
# Purpose: Authenticates deployment tools (GitHub Actions, Azure CLI, etc.)
# 
# Security: Marked as sensitive - won't show in console output
# Usage:
#   - For GitHub Actions: Store in GitHub Secrets as AZURE_STATIC_WEB_APPS_API_TOKEN
#   - For manual deploy: Run "terraform output -raw static_web_app_api_key"
#
# IMPORTANT: Keep this secret! Anyone with this key can deploy to your app
# To view: terraform output -raw static_web_app_api_key
output "static_web_app_api_key" {
  description = "API key for deploying to the Static Web App"
  value       = azurerm_static_web_app.main.api_key
  sensitive   = true  # Prevents accidental exposure in logs and console
}
