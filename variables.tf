variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-2do-app"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US 2"
}

variable "static_web_app_name" {
  description = "Name of the Azure Static Web App"
  type        = string
  default     = "swa-2do-app"
}

variable "sku_tier" {
  description = "SKU tier for Static Web App (Free or Standard)"
  type        = string
  default     = "Free"
}

variable "sku_size" {
  description = "SKU size for Static Web App (Free or Standard)"
  type        = string
  default     = "Free"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Application = "2do"
    ManagedBy   = "Terraform"
  }
}
