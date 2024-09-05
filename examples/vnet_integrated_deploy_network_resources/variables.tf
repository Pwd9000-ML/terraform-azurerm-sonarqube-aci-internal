## Common ##
variable "network_resource_group_name" {
  type        = string
  default     = "Terraform-Sonarqube-internal-vnet-rg"
  description = "Name of the resource group to create where sonarqube networking resources will be hosted."
  nullable    = false
}

variable "sonarqube_resource_group_name" {
  type        = string
  default     = "Terraform-Sonarqube-internal-rg"
  description = "Name of the resource group to create where sonarqube instance resources will be hosted."
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
    TagName = "TagValue"
  }
  description = "A map of key value pairs that is used to tag resources created."
}

## Networking ##
variable "create_networking_prereqs" {
  type        = bool
  default     = false
  description = "Create networking resources required for ACI to be deployed."
}
variable "virtual_network_name" {
  type        = string
  default     = "sonarqube-vnet"
  description = "Name of the virtual network to create."
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.1.0.0/16"]
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
      subnet_address_space                          = ["10.1.0.0/24"]
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
      subnet_address_space                          = ["10.1.1.0/24"]
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
  type = list(string)
  default = [
    "privatelink.vaultcore.azure.net",
    "privatelink.file.core.windows.net",
    "privatelink.database.windows.net",
    "pwd9000.local"
  ]
  description = "Private DNS zones to create."
}

variable "resource_subnet_name" {
  type        = string
  default     = "sonarqube-resource-sub"
  description = "The name for the resource subnet, used in data source to get subnet ID."
  nullable    = false
}

variable "delegated_subnet_name" {
  type        = string
  default     = "sonarqube-delegated-sub"
  description = "The name for the aci delegated subnet, used in data source to get subnet ID."
  nullable    = false
}

###Key Vault###
variable "kv_config" {
  type = object({
    name = string
    sku  = string
  })
  default = {
    name = "sonarqubekv9000"
    sku  = "standard"
  }
  description = "Key Vault configuration object to create azure key vault to store sonarqube aci sql creds."
  nullable    = false
}

variable "keyvault_firewall_default_action" {
  type        = string
  default     = "Deny"
  description = "Default action for keyvault firewall rules."
}

variable "keyvault_firewall_bypass" {
  type        = string
  default     = "AzureServices"
  description = "List of keyvault firewall rules to bypass."
}

variable "keyvault_firewall_allowed_ips" {
  type        = list(string)
  default     = ["0.0.0.0/0"] #for testing purposes only - allow all IPs
  description = "value of keyvault firewall allowed ip rules."
}

## Storage - File ##
variable "sa_config" {
  type = object({
    name                     = string
    account_kind             = string
    account_tier             = string
    account_replication_type = string
    access_tier              = string
    min_tls_version          = string
    is_hns_enabled           = bool
  })
  default = {
    name                     = "sonarqubesa9000"
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"
    min_tls_version          = "TLS1_2"
    is_hns_enabled           = false
  }
  description = "Storage configuration object to create persistent azure file shares for sonarqube aci."
  nullable    = false
}

variable "shares_config" {
  type = list(object({
    share_name = string
    quota_gb   = number
  }))
  default = [
    {
      share_name = "data"
      quota_gb   = 10
    },
    {
      share_name = "extensions"
      quota_gb   = 10
    },
    {
      share_name = "logs"
      quota_gb   = 10
    },
    {
      share_name = "conf"
      quota_gb   = 1
    }
  ]
  description = "Sonarqube file shares."
}

variable "storage_firewall_default_action" {
  type        = string
  default     = "Deny"
  description = "Default action for storage firewall rules."
}

variable "storage_firewall_bypass" {
  type        = list(string)
  default     = ["AzureServices"]
  description = "List of storage firewall rules to bypass."
}

variable "storage_firewall_allowed_ips" {
  type        = list(string)
  default     = ["0.0.0.0/0"] #for testing purposes only - allow all IPs
  description = "value of storage firewall allowed ip rules."
}

###Azure SQL Server###
variable "pass_length" {
  type        = number
  default     = 36
  description = "Password length for sql admin creds. (Stored in sonarqube key vault)"
}

variable "sql_admin_username" {
  type        = string
  default     = "Sonar-Admin"
  description = "Username for sql admin creds. (Stored in sonarqube key vault)"
}

variable "mssql_config" {
  type = object({
    name    = string
    version = string
  })
  default = {
    name    = "sonarqubemssql6283"
    version = "12.0"
  }
  description = "MSSQL configuration object to create persistent SQL server instance for sonarqube aci."
  nullable    = false
}

variable "mssql_fw_rules" {
  type        = list(list(string))
  default     = [["AllowAll", "0.0.0.0", "0.0.0.0"]] #for testing purposes only - allow all IPs
  description = "List of SQL firewall rules in format: [[rule1, startIP, endIP],[rule2, startIP, endIP]] etc."
}

###MSSQL Database###
variable "mssql_db_config" {
  type = object({
    db_name                     = string
    collation                   = string
    create_mode                 = string
    license_type                = string
    max_size_gb                 = number
    min_capacity                = number
    auto_pause_delay_in_minutes = number
    read_scale                  = bool
    sku_name                    = string
    storage_account_type        = string
    zone_redundant              = bool
    point_in_time_restore_days  = number
    backup_interval_in_hours    = number
  })
  default = {
    db_name                     = "sonarqubemssqldb9000"
    collation                   = "SQL_Latin1_General_CP1_CS_AS"
    create_mode                 = "Default"
    license_type                = null
    max_size_gb                 = 128
    min_capacity                = 1
    auto_pause_delay_in_minutes = 60
    read_scale                  = false
    sku_name                    = "GP_S_Gen5_2"
    storage_account_type        = "Zone"
    zone_redundant              = false
    point_in_time_restore_days  = 7
    backup_interval_in_hours    = 24
  }
  description = "MSSQL database configuration object to create persistent azure SQL db for sonarqube aci."
}

variable "aci_group_config" {
  type = object({
    container_group_name = string
    ip_address_type      = string
    os_type              = string
    restart_policy       = string
  })
  default = {
    container_group_name = "sonarqubeaci9000"
    ip_address_type      = "Private"
    os_type              = "Linux"
    restart_policy       = "Never"
  }
  description = "Container group configuration object to create sonarqube aci with caddy reverse proxy."
  nullable    = false
}

variable "sonar_config" {
  type = object({
    container_name                  = string
    container_image                 = string
    container_cpu                   = number
    container_memory                = number
    container_environment_variables = map(string)
    container_commands              = list(string)
  })
  default = {
    container_name                  = "sonarqube-server"
    container_image                 = "ghcr.io/metrostar/quartz/ironbank/big-bang/sonarqube-9:9.9.4-community"
    container_cpu                   = 2
    container_memory                = 8
    container_environment_variables = null
    container_commands              = []
  }
  description = "Sonarqube container configuration object to create sonarqube aci."
}

variable "caddy_config" {
  type = object({
    container_name                  = string
    container_image                 = string
    container_cpu                   = number
    container_memory                = number
    container_environment_variables = map(string)
    container_commands              = list(string)
  })
  default = {
    container_name                  = "caddy-reverse-proxy"
    container_image                 = "ghcr.io/sashkab/docker-caddy2/docker-caddy2:latest"
    container_cpu                   = 1
    container_memory                = 1
    container_environment_variables = null
    container_commands              = ["caddy", "reverse-proxy", "--from", "custom.domain.local", "--to", "localhost:9000", "--internal-certs"]
  }
  description = "Caddy container configuration object to create caddy reverse proxy aci - internal certs (self signed)."
}

variable "aci_private_dns_record" {
  type        = bool
  default     = true
  description = "Create private dns record for internal sonarqube instance in '.local'(internal) Azure private DNS zone. (Remember to add dns zone link to other peered vnets to resolve aci dns record.) If false, add private IP to hosts file to resolve the dns record for internal sonarqube instance: 'custom.domain.local'."
}

variable "local_dns_zone_name" {
  type        = string
  default     = "pwd9000.local"
  description = "Private Azure dns zone name for the '.local'(internal) DNS zone to add dns record for internal sonarqube instance. (Remember to add dns zone link to other peered vnets to resolve aci dns record.) Otherwise use hosts file to resolve the dns record for internal sonarqube instance: 'custom.domain.local'."
}

variable "sonarqube_private_dns_record" {
  type        = string
  default     = "sonar"
  description = "Private dns A record for sonarqube instance. (Remember to add dns zone link to other peered vnets to resolve aci dns record.) Otherwise use hosts file to resolve the dns record for internal sonarqube instance: 'custom.domain.local'."
}