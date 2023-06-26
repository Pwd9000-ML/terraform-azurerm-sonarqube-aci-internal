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