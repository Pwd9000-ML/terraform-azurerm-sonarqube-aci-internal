variable "network_resource_group_name" {
  type        = string
  description = "Name of the resource group to where networking resources will be hosted."
  nullable    = false
}

variable "location" {
  type        = string
  default     = "uksouth"
  description = "Azure region where resources will be hosted."
}

variable "tags" {
  type = map(string)
  default = {
    Terraform   = "True"
    Description = "Sonarqube Private Networking Resource."
    Author      = "Marcel Lupo"
    GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal"
  }
  description = "A map of key value pairs that is used to tag resources created."
}

variable "virtual_network_name" {
  type        = string
  default     = "sonarqube-vnet"
  description = "Name of the virtual network to create."
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.3.0.0/16"]
  description = "value of the address space for the virtual network."
}

variable "subnet_config" {
  type = list(object({
    subnet_name                                   = string
    subnet_address_space                          = list(string)
    service_endpoints                             = list(string)
    private_endpoint_network_policies_enabled     = bool
    private_link_service_network_policies_enabled = bool
  }))
  default = [
    {
      subnet_name                                   = "sonarqube-resource-sub"
      subnet_address_space                          = ["10.3.0.0/24"]
      service_endpoints                             = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
      private_endpoint_network_policies_enabled     = false
      private_link_service_network_policies_enabled = false
    }
  ]
  description = "A list of subnet configuration objects to create subnets in the virtual network."
}

variable "subnet_config_delegated_aci" {
  type = list(object({
    subnet_name                                   = string
    subnet_address_space                          = list(string)
    service_endpoints                             = list(string)
    private_endpoint_network_policies_enabled     = bool
    private_link_service_network_policies_enabled = bool
    delegation_name                               = string
    delegation_service                            = string
    delegation_ations                             = list(string)
  }))
  default = [
    {
      subnet_name                                   = "sonarqube-delegated-sub"
      subnet_address_space                          = ["10.3.1.0/24"]
      service_endpoints                             = []
      private_endpoint_network_policies_enabled     = false
      private_link_service_network_policies_enabled = false
      delegation_name                               = "aci-sub-delegation"
      delegation_service                            = "Microsoft.ContainerInstance/containerGroups"
      delegation_ations                             = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  ]
  description = "A list of subnet configuration objects to create subnets in the virtual network. - delegated to ACI"
}

variable "private_dns_zones" {
  type        = list(string)
  default     = ["privatelink.vaultcore.azure.net", "privatelink.file.core.windows.net", "privatelink.database.windows.net", "pwd9000.local"]
  description = "Private DNS zones to create and link to VNET."
}