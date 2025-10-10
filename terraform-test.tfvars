# Test Environment Configuration
resource_group_name  = "rg-2doHealth-app-test"
location             = "West Europe"
static_web_app_name  = "swa-2doHealth-app-test"
sku_tier             = "Free"
sku_size             = "Free"

tags = {
  Environment = "Test"
  Application = "2doHealth"
  ManagedBy   = "Terraform"
  Owner       = "Angli"
}