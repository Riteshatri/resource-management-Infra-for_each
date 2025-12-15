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
  subscription_id = "aapkeSubscriptionKiId"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "apkeResourceGroupKaNaam"
    storage_account_name = "aapkeStorageAccountKaNaam"
    container_name       = "apkeStorageContainerKaNaam"
    key                  = "apkiStatefileKaNaam.tfstate"
  }
}
