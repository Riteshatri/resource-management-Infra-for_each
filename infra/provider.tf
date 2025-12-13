terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "98473d5b-c639-404e-9bf2-91559fe65ff8"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "ritkarga"
    storage_account_name = "ritkasaa"
    container_name       = "ritkasca"
    key                  = "website.tfstate"
  }
}