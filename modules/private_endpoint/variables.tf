variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the resources will be created."
}

variable "location" {
  type        = string
  default     = "uksouth"
  description = "The location/region where the resources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet to attach the privaye endpoint to."
}

variable "private_endpoint_name" {
  type        = string
  description = "The name of the Private Endpoint."
}

variable "private_service_connection_name" {
  type        = string
  description = "The name of the Private Service Connection."
}

variable "private_connection_resource_id" {
  type        = string
  description = "The Resource ID which the private endpoint should be created for."
}

variable "private_dns_zone_group" {
  type = list(object({
    enabled              = bool
    name                 = string
    private_dns_zone_ids = list(string)
  }))
  default     = []
  description = "A list of private dns zone groups to associate with the private endpoint."
}

variable "is_manual_connection" {
  type        = bool
  description = "Boolean flag to specify whether the connection should be manual."
  default     = false
}

variable "subresource_names" {
  type        = list(string)
  description = "A list of subresource names which the Private Endpoint is able to connect to. subresource_names corresponds to group_id. Changing this forces a new resource to be created."
}

variable "tags" {
  type = map(any)
  default = {
    Terraform   = "True"
    Description = "Sonarqube Private Endpoint Resource."
    Author      = "Marcel Lupo"
    GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal"
  }
  description = "A Map of tags to be applied to the resources."
}