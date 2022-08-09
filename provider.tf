terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.17.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = ">=2.6.0"
    }
  }
}

provider "azurerm" {
  features {}
}
