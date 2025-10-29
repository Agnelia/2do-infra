# Production Environment Configuration
resource_group_name = "rg-2doHealth-app-prod-v2"
location            = "West Europe"
static_web_app_name = "swa-2doHealth-app-prod"
sku_tier            = "Free"
sku_size            = "Free"

tags = {
  Environment = "Production"
  Application = "2doHealth"
  ManagedBy   = "Terraform"
  Owner       = "Angli"
}