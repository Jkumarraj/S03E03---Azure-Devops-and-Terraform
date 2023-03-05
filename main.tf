# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tf_rg_blobstore"
    storage_account_name = "tfstatestoreblob"
    container_name       = "tfstate"
    key                  = "weatherapi.terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

variable "imageBuild" {
  type        = string
  description = "Latest Image Build"
}

resource "azurerm_resource_group" "tf_rg_test" {
  name     = "tf-main-rg"
  location = "eastus"
}

resource "azurerm_container_group" "tf_cg_test" {
  name                = "weatherapi"
  location            = azurerm_resource_group.tf_rg_test.location
  resource_group_name = azurerm_resource_group.tf_rg_test.name

  ip_address_type = "Public"
  dns_name_label  = "jkweatherapi"
  os_type         = "Linux"

  container {
    name   = "weatherapi"
    image  = "jkumarraj/weatherapi:${var.imageBuild}"
    cpu    = "1"
    memory = "1"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
  timeouts {
    create = "4m"
  }
}
