variable "network_resource_group_name" {
  type        = string
  default     = null
  description = "Name of the resource group to create where sonarqube networking resources will be hosted."
}

variable "sonarqube_resource_group_name" {
  type        = string
  default     = null
  description = "Name of the resource group to create where sonarqube instance resources will be hosted."
}

variable "location" {
  type        = string
  default     = null
  description = "Azure region where resources will be hosted."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of key value pairs that is used to tag resources created."
}

### Specify existing networking resources ###
variable "virtual_network_name" {
  type        = string
  default     = null
  description = "Name of the virtual network where resources are attached."
}

variable "private_dns_zones" {
  type        = list(string)
  default     = []
  description = "Private DNS zones to create and link to VNET."
}

### Supply subnet names to retrieve subnet IDs ###
variable "resource_subnet_name" {
  type        = string
  default     = null
  description = "The name for the resource subnet, used in data source to get subnet ID."
}

variable "delegated_subnet_name" {
  type        = string
  default     = null
  description = "The name for the aci delegated subnet, used in data source to get subnet ID."
}