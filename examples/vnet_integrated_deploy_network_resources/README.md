# SonarQube Internal/Private Azure Container Instance - Example 1

## VNET integrated deployment - networking resources deployed separately

In this example virtual network prerequisites such as the VNET, subnets and private DNS zones are deployed as separate Terraform resources for use with a **VNET integrated Azure Container Instance** to run **SonarQube** inside of an internal/private Azure network using a self signed certificate (using a **Caddy sidecar container**) that can be peered to other networks in the organisation to utilise SonarQube inside of the organisation privately.  

Networking prerequisites are created separately to allow for reuse of the networking resources, and then the SonarQube instance is created using the module.  

See **[VNET integrated deployment - networking resources deployed (Built-in)](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/examples/vnet_integrated_with_builtin_network_resources):**  
For an example of how to create the required **networking prerequisites** and **SonarQube instance** in one module by setting the parameter: `"create_networking_prereqs = true"`.  

See **[VNET integrated deployment - existing network resources](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/examples/vnet_integrated_with_existing_network_resources):**  
For an example on how to create and integrate the SonarQube instance on exisiting network resources by setting the parameter: `"create_networking_prereqs = false"`.  

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sonarcube-aci-internal"></a> [sonarcube-aci-internal](#module\_sonarcube-aci-internal) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone.private_dns_zones](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet-link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_resource_group.sonarqube_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sonarqube_vnet_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.resource_subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.sonarqube_sub_del](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.sonarqube_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_integer.number](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aci_group_config"></a> [aci\_group\_config](#input\_aci\_group\_config) | Container group configuration object to create sonarqube aci with caddy reverse proxy. | <pre>object({<br>    container_group_name = string<br>    ip_address_type      = string<br>    os_type              = string<br>    restart_policy       = string<br>  })</pre> | <pre>{<br>  "container_group_name": "sonarqubeaci9000",<br>  "ip_address_type": "Private",<br>  "os_type": "Linux",<br>  "restart_policy": "Never"<br>}</pre> | no |
| <a name="input_aci_private_dns_record"></a> [aci\_private\_dns\_record](#input\_aci\_private\_dns\_record) | Create private dns record for internal sonarqube instance in '.local'(internal) Azure private DNS zone. (Remember to add dns zone link to other peered vnets to resolve aci dns record.) If false, add private IP to hosts file to resolve the dns record for internal sonarqube instance: 'custom.domain.local'. | `bool` | `true` | no |
| <a name="input_caddy_config"></a> [caddy\_config](#input\_caddy\_config) | Caddy container configuration object to create caddy reverse proxy aci - internal certs (self signed). | <pre>object({<br>    container_name                  = string<br>    container_image                 = string<br>    container_cpu                   = number<br>    container_memory                = number<br>    container_environment_variables = map(string)<br>    container_commands              = list(string)<br>  })</pre> | <pre>{<br>  "container_commands": [<br>    "caddy",<br>    "reverse-proxy",<br>    "--from",<br>    "custom.domain.local",<br>    "--to",<br>    "localhost:9000",<br>    "--internal-certs"<br>  ],<br>  "container_cpu": 1,<br>  "container_environment_variables": null,<br>  "container_image": "caddy:latest",<br>  "container_memory": 1,<br>  "container_name": "caddy-reverse-proxy"<br>}</pre> | no |
| <a name="input_delegated_subnet_name"></a> [delegated\_subnet\_name](#input\_delegated\_subnet\_name) | The name for the aci delegated subnet, used in data source to get subnet ID. | `string` | `"sonarqube-delegated-sub"` | no |
| <a name="input_keyvault_firewall_allowed_ips"></a> [keyvault\_firewall\_allowed\_ips](#input\_keyvault\_firewall\_allowed\_ips) | value of keyvault firewall allowed ip rules. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_keyvault_firewall_bypass"></a> [keyvault\_firewall\_bypass](#input\_keyvault\_firewall\_bypass) | List of keyvault firewall rules to bypass. | `string` | `"AzureServices"` | no |
| <a name="input_keyvault_firewall_default_action"></a> [keyvault\_firewall\_default\_action](#input\_keyvault\_firewall\_default\_action) | Default action for keyvault firewall rules. | `string` | `"Deny"` | no |
| <a name="input_kv_config"></a> [kv\_config](#input\_kv\_config) | Key Vault configuration object to create azure key vault to store sonarqube aci sql creds. | <pre>object({<br>    name = string<br>    sku  = string<br>  })</pre> | <pre>{<br>  "name": "sonarqubekv9000",<br>  "sku": "standard"<br>}</pre> | no |
| <a name="input_local_dns_zone_name"></a> [local\_dns\_zone\_name](#input\_local\_dns\_zone\_name) | Private Azure dns zone name for the '.local'(internal) DNS zone to add dns record for internal sonarqube instance. (Remember to add dns zone link to other peered vnets to resolve aci dns record.) Otherwise use hosts file to resolve the dns record for internal sonarqube instance: 'custom.domain.local'. | `string` | `"pwd9000.local"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where resources will be hosted. | `string` | `"uksouth"` | no |
| <a name="input_mssql_config"></a> [mssql\_config](#input\_mssql\_config) | MSSQL configuration object to create persistent SQL server instance for sonarqube aci. | <pre>object({<br>    name    = string<br>    version = string<br>  })</pre> | <pre>{<br>  "name": "sonarqubemssql9000",<br>  "version": "12.0"<br>}</pre> | no |
| <a name="input_mssql_db_config"></a> [mssql\_db\_config](#input\_mssql\_db\_config) | MSSQL database configuration object to create persistent azure SQL db for sonarqube aci. | <pre>object({<br>    db_name                     = string<br>    collation                   = string<br>    create_mode                 = string<br>    license_type                = string<br>    max_size_gb                 = number<br>    min_capacity                = number<br>    auto_pause_delay_in_minutes = number<br>    read_scale                  = bool<br>    sku_name                    = string<br>    storage_account_type        = string<br>    zone_redundant              = bool<br>    point_in_time_restore_days  = number<br>    backup_interval_in_hours    = number<br>  })</pre> | <pre>{<br>  "auto_pause_delay_in_minutes": 60,<br>  "backup_interval_in_hours": 24,<br>  "collation": "SQL_Latin1_General_CP1_CS_AS",<br>  "create_mode": "Default",<br>  "db_name": "sonarqubemssqldb9000",<br>  "license_type": null,<br>  "max_size_gb": 128,<br>  "min_capacity": 1,<br>  "point_in_time_restore_days": 7,<br>  "read_scale": false,<br>  "sku_name": "GP_S_Gen5_2",<br>  "storage_account_type": "Zone",<br>  "zone_redundant": false<br>}</pre> | no |
| <a name="input_mssql_fw_rules"></a> [mssql\_fw\_rules](#input\_mssql\_fw\_rules) | List of SQL firewall rules in format: [[rule1, startIP, endIP],[rule2, startIP, endIP]] etc. | `list(list(string))` | <pre>[<br>  [<br>    "AllowAll",<br>    "0.0.0.0",<br>    "0.0.0.0"<br>  ]<br>]</pre> | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | Name of the resource group to create where sonarqube networking resources will be hosted. | `string` | `"Terraform-Sonarqube-internal-vnet-rg"` | no |
| <a name="input_pass_length"></a> [pass\_length](#input\_pass\_length) | Password length for sql admin creds. (Stored in sonarqube key vault) | `number` | `24` | no |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | Private DNS zones to create. | `list(string)` | <pre>[<br>  "privatelink.vaultcore.azure.net",<br>  "privatelink.file.core.windows.net",<br>  "privatelink.database.windows.net",<br>  "pwd9000.local"<br>]</pre> | no |
| <a name="input_resource_subnet_name"></a> [resource\_subnet\_name](#input\_resource\_subnet\_name) | The name for the resource subnet, used in data source to get subnet ID. | `string` | `"sonarqube-resource-sub"` | no |
| <a name="input_sa_config"></a> [sa\_config](#input\_sa\_config) | Storage configuration object to create persistent azure file shares for sonarqube aci. | <pre>object({<br>    name                      = string<br>    account_kind              = string<br>    account_tier              = string<br>    account_replication_type  = string<br>    access_tier               = string<br>    enable_https_traffic_only = bool<br>    min_tls_version           = string<br>    is_hns_enabled            = bool<br>  })</pre> | <pre>{<br>  "access_tier": "Hot",<br>  "account_kind": "StorageV2",<br>  "account_replication_type": "LRS",<br>  "account_tier": "Standard",<br>  "enable_https_traffic_only": true,<br>  "is_hns_enabled": false,<br>  "min_tls_version": "TLS1_2",<br>  "name": "sonarqubesa9000"<br>}</pre> | no |
| <a name="input_shares_config"></a> [shares\_config](#input\_shares\_config) | Sonarqube file shares. | <pre>list(object({<br>    share_name = string<br>    quota_gb   = number<br>  }))</pre> | <pre>[<br>  {<br>    "quota_gb": 10,<br>    "share_name": "data"<br>  },<br>  {<br>    "quota_gb": 10,<br>    "share_name": "extensions"<br>  },<br>  {<br>    "quota_gb": 10,<br>    "share_name": "logs"<br>  },<br>  {<br>    "quota_gb": 1,<br>    "share_name": "conf"<br>  }<br>]</pre> | no |
| <a name="input_sonar_config"></a> [sonar\_config](#input\_sonar\_config) | Sonarqube container configuration object to create sonarqube aci. | <pre>object({<br>    container_name                  = string<br>    container_image                 = string<br>    container_cpu                   = number<br>    container_memory                = number<br>    container_environment_variables = map(string)<br>    container_commands              = list(string)<br>  })</pre> | <pre>{<br>  "container_commands": [],<br>  "container_cpu": 2,<br>  "container_environment_variables": null,<br>  "container_image": "sonarqube:lts-community",<br>  "container_memory": 8,<br>  "container_name": "sonarqube-server"<br>}</pre> | no |
| <a name="input_sonarqube_private_dns_record"></a> [sonarqube\_private\_dns\_record](#input\_sonarqube\_private\_dns\_record) | Private dns A record for sonarqube instance. (Remember to add dns zone link to other peered vnets to resolve aci dns record.) Otherwise use hosts file to resolve the dns record for internal sonarqube instance: 'custom.domain.local'. | `string` | `"sonar"` | no |
| <a name="input_sonarqube_resource_group_name"></a> [sonarqube\_resource\_group\_name](#input\_sonarqube\_resource\_group\_name) | Name of the resource group to create where sonarqube instance resources will be hosted. | `string` | `"Terraform-Sonarqube-internal-rg"` | no |
| <a name="input_sql_admin_username"></a> [sql\_admin\_username](#input\_sql\_admin\_username) | Username for sql admin creds. (Stored in sonarqube key vault) | `string` | `"Sonar-Admin"` | no |
| <a name="input_storage_firewall_allowed_ips"></a> [storage\_firewall\_allowed\_ips](#input\_storage\_firewall\_allowed\_ips) | value of storage firewall allowed ip rules. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_storage_firewall_bypass"></a> [storage\_firewall\_bypass](#input\_storage\_firewall\_bypass) | List of storage firewall rules to bypass. | `list(string)` | <pre>[<br>  "AzureServices"<br>]</pre> | no |
| <a name="input_storage_firewall_default_action"></a> [storage\_firewall\_default\_action](#input\_storage\_firewall\_default\_action) | Default action for storage firewall rules. | `string` | `"Deny"` | no |
| <a name="input_subnet_config"></a> [subnet\_config](#input\_subnet\_config) | A list of subnet configuration objects to create subnets in the virtual network. | <pre>list(object({<br>    subnet_name                                   = string<br>    subnet_address_space                          = list(string)<br>    service_endpoints                             = list(string)<br>    private_endpoint_network_policies_enabled     = bool<br>    private_link_service_network_policies_enabled = bool<br>  }))</pre> | <pre>[<br>  {<br>    "private_endpoint_network_policies_enabled": false,<br>    "private_link_service_network_policies_enabled": false,<br>    "service_endpoints": [<br>      "Microsoft.Storage",<br>      "Microsoft.Sql",<br>      "Microsoft.KeyVault"<br>    ],<br>    "subnet_address_space": [<br>      "10.1.0.0/24"<br>    ],<br>    "subnet_name": "sonarqube-resource-sub"<br>  }<br>]</pre> | no |
| <a name="input_subnet_config_delegated_aci"></a> [subnet\_config\_delegated\_aci](#input\_subnet\_config\_delegated\_aci) | A list of subnet configuration objects to create subnets in the virtual network. - delegated to ACI | <pre>list(object({<br>    subnet_name                                   = string<br>    subnet_address_space                          = list(string)<br>    service_endpoints                             = list(string)<br>    private_endpoint_network_policies_enabled     = bool<br>    private_link_service_network_policies_enabled = bool<br>    delegation_name                               = string<br>    delegation_service                            = string<br>    delegation_ations                             = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "delegation_ations": [<br>      "Microsoft.Network/virtualNetworks/subnets/action"<br>    ],<br>    "delegation_name": "aci-sub-delegation",<br>    "delegation_service": "Microsoft.ContainerInstance/containerGroups",<br>    "private_endpoint_network_policies_enabled": false,<br>    "private_link_service_network_policies_enabled": false,<br>    "service_endpoints": [],<br>    "subnet_address_space": [<br>      "10.1.1.0/24"<br>    ],<br>    "subnet_name": "sonarqube-delegated-sub"<br>  }<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key value pairs that is used to tag resources created. | `map(string)` | <pre>{<br>  "TagName": "TagValue"<br>}</pre> | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the virtual network to create. | `string` | `"sonarqube-vnet"` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | value of the address space for the virtual network. | `list(string)` | <pre>[<br>  "10.1.0.0/16"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->