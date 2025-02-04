provider "azurerm" {
  features {}
  #skip_provider_registration = true
  resource_provider_registrations = "none"
}
terraform {
  backend "azurerm" {
    
  }
}