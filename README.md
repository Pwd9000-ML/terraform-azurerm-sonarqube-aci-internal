[![Automated-Dependency-Tests-and-Release](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/actions/workflows/dependency-tests.yml/badge.svg)](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/actions/workflows/dependency-tests.yml) [![Dependabot](https://badgen.net/badge/Dependabot/enabled/green?icon=dependabot)](https://dependabot.com/)

# Module: VNET integrated SonarQube Azure Container Instance (+ Automatic SSL self-signed certificate)

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/master/assets/main.png)

## Description

Terraform Registry module for setting up an (internal/private VNET integrated) AZURE hosted SonarQube ACI instance including private endpointed persistent PaaS Database (Azure SQL), PaaS File Share (Azure Files) and custom local domain using reverse proxy (Caddy) sidecar container with self-signed generated certificate.

See **[VNET integrated deployment - networking resources deployed separately](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/examples/vnet_integrated_deploy_network_resources):**  
For an example of how to create the required **networking prerequisites** separately to the **SonarQube instance** by setting the parameter: `"var.create_networking_prereqs = false"`.  

See **[VNET integrated deployment - networking resources deployed (Built-in)](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/examples/vnet_integrated_with_builtin_network_resources):**  
For an example of how to create the required **networking prerequisites** and **SonarQube instance** in one module by setting the parameter: `"var.create_networking_prereqs = true"`.  

See **[VNET integrated deployment - existing network resources](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/examples/vnet_integrated_with_existing_network_resources):**  
For an example on how to create and integrate the SonarQube instance on existing network resources by setting the parameter: `"create_networking_prereqs = false"`.

This module is published on the **[Public Terraform Registry - sonarqube-aci-internal](https://registry.terraform.io/modules/Pwd9000-ML/sonarqube-aci-internal/azurerm/latest)**  

## Network prerequisites

The following networking resources are required to be created before deploying the SonarQube instance:  

- **Virtual Network** (VNET)
- **Private DNS Zones** (Private DNS Zones for privatelink resources `[Keyvault, MsSQL and File Storage]`, and a custom `[local]` domain)

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/master/assets/networking1.png)  

- **Subnets** (Resource Subnet to private endpoint supporting resources, and a subnet delegated for Azure Container Instances)

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/master/assets/networking2.png)  

Supporting PaaS resources are private endpointed and integrated with the VNET on the **resources subnet** and linked with DNS private zones attached to the VNET.  

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/master/assets/networking3.png)

After the **SonarQube** instance is deployed, the **SonarQube** instance will be integrated with the VNET on the **delegated-subnet** and the private IP "A-record" linked with the DNS private `[local]` zone attached to the VNET.

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/master/assets/networking4.png)

## SonarQube instance

The following resources are deployed as part of the SonarQube instance:  

- **Azure Container Group** containing the SonarQube ACI and Caddy sidecar ACI with a **private IP** on the **delegated-subnet** of the VNET.  
- **Azure SQL Database** (PaaS) with a **private endpoint** on the **resources subnet** of the VNET.  
- **Azure File Share** (PaaS) with a **private endpoint** on the **resources subnet** of the VNET.  
- **Azure Key Vault** (PaaS) with a **private endpoint** on the **resources subnet** of the VNET.  

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/master/assets/resources.png)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.62.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.62.1 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_create_networking_prereqs"></a> [create\_networking\_prereqs](#module\_create\_networking\_prereqs) | ./modules/network_prereqs | n/a |
| <a name="module_private_endpoint_kv"></a> [private\_endpoint\_kv](#module\_private\_endpoint\_kv) | ./modules/private_endpoint | n/a |
| <a name="module_private_endpoint_mssql"></a> [private\_endpoint\_mssql](#module\_private\_endpoint\_mssql) | ./modules/private_endpoint | n/a |
| <a name="module_private_endpoint_sa"></a> [private\_endpoint\_sa](#module\_private\_endpoint\_sa) | ./modules/private_endpoint | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_group.sonarqube_aci_private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group) | resource |
| [azurerm_key_vault.sonarqube_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.password_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.username_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_mssql_database.sonarqube_mssql_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_firewall_rule.sonarqube_mssql_fw_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.sonarqube_mssql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_virtual_network_rule.mssql_vnet_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_network_rule) | resource |
| [azurerm_private_dns_a_record.aci_a_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_role_assignment.kv_role_assigment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.sonarqube_sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_share.sonarqube](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurerm_storage_share_file.sonar_properties](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share_file) | resource |
| [random_password.sql_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_private_dns_zone.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.mssql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_subnet.delegated_subnet_aci](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.resource_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aci_group_config"></a> [aci\_group\_config](#input\_aci\_group\_config) | Container group configuration object to create sonarqube aci with caddy reverse proxy. | <pre>object({<br>    container_group_name = string<br>    ip_address_type      = string<br>    os_type              = string<br>    restart_policy       = string<br>  })</pre> | <pre>{<br>  "container_group_name": "sonarqubeaci9000",<br>  "ip_address_type": "Private",<br>  "os_type": "Linux",<br>  "restart_policy": "Never"<br>}</pre> | no |
| <a name="input_aci_private_dns_record"></a> [aci\_private\_dns\_record](#input\_aci\_private\_dns\_record) | Create private dns record for internal sonarqube instance in '.local'(internal) Azure private DNS zone. (Remember to add dns zone link to other peered vnets to resolve aci dns record.) If false, add private IP to hosts file to resolve the dns record for internal sonarqube instance: 'custom.domain.local'. | `bool` | `false` | no |
| <a name="input_caddy_config"></a> [caddy\_config](#input\_caddy\_config) | Caddy container configuration object to create caddy reverse proxy aci - internal certs (self signed). | <pre>object({<br>    container_name                  = string<br>    container_image                 = string<br>    container_cpu                   = number<br>    container_memory                = number<br>    container_environment_variables = map(string)<br>    container_commands              = list(string)<br>  })</pre> | <pre>{<br>  "container_commands": [<br>    "caddy",<br>    "reverse-proxy",<br>    "--from",<br>    "custom.domain.local",<br>    "--to",<br>    "localhost:9000",<br>    "--internal-certs"<br>  ],<br>  "container_cpu": 1,<br>  "container_environment_variables": null,<br>  "container_image": "caddy:latest",<br>  "container_memory": 1,<br>  "container_name": "caddy-reverse-proxy"<br>}</pre> | no |
| <a name="input_create_networking_prereqs"></a> [create\_networking\_prereqs](#input\_create\_networking\_prereqs) | Create networking resources required for ACI to be deployed. | `bool` | `false` | no |
| <a name="input_delegated_subnet_name"></a> [delegated\_subnet\_name](#input\_delegated\_subnet\_name) | The name for the aci delegated subnet, used in data source to get subnet ID. | `string` | n/a | yes |
| <a name="input_keyvault_firewall_allowed_ips"></a> [keyvault\_firewall\_allowed\_ips](#input\_keyvault\_firewall\_allowed\_ips) | value of keyvault firewall allowed ip rules. | `list(string)` | `[]` | no |
| <a name="input_keyvault_firewall_bypass"></a> [keyvault\_firewall\_bypass](#input\_keyvault\_firewall\_bypass) | List of keyvault firewall rules to bypass. | `string` | `"AzureServices"` | no |
| <a name="input_keyvault_firewall_default_action"></a> [keyvault\_firewall\_default\_action](#input\_keyvault\_firewall\_default\_action) | Default action for keyvault firewall rules. | `string` | `"Deny"` | no |
| <a name="input_kv_config"></a> [kv\_config](#input\_kv\_config) | Key Vault configuration object to create azure key vault to store sonarqube aci sql creds. | <pre>object({<br>    name = string<br>    sku  = string<br>  })</pre> | <pre>{<br>  "name": "sonarqubekv9000",<br>  "sku": "standard"<br>}</pre> | no |
| <a name="input_local_dns_zone_name"></a> [local\_dns\_zone\_name](#input\_local\_dns\_zone\_name) | Private Azure dns zone name for the '.local'(internal) DNS zone to add dns record for internal sonarqube instance. (Remember to add dns zone link to other peered vnets to resolve aci dns record.) Otherwise use hosts file to resolve the dns record for internal sonarqube instance: 'custom.domain.local'. | `string` | `"pwd9000.local"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region to deploy resources to. | `string` | `"uksouth"` | no |
| <a name="input_mssql_config"></a> [mssql\_config](#input\_mssql\_config) | MSSQL configuration object to create persistent SQL server instance for sonarqube aci. | <pre>object({<br>    name    = string<br>    version = string<br>  })</pre> | <pre>{<br>  "name": "sonarqubemssql9000",<br>  "version": "12.0"<br>}</pre> | no |
| <a name="input_mssql_db_config"></a> [mssql\_db\_config](#input\_mssql\_db\_config) | MSSQL database configuration object to create persistent azure SQL db for sonarqube aci. | <pre>object({<br>    db_name                     = string<br>    collation                   = string<br>    create_mode                 = string<br>    license_type                = string<br>    max_size_gb                 = number<br>    min_capacity                = number<br>    auto_pause_delay_in_minutes = number<br>    read_scale                  = bool<br>    sku_name                    = string<br>    storage_account_type        = string<br>    zone_redundant              = bool<br>    point_in_time_restore_days  = number<br>    backup_interval_in_hours    = number<br>  })</pre> | <pre>{<br>  "auto_pause_delay_in_minutes": 60,<br>  "backup_interval_in_hours": 24,<br>  "collation": "SQL_Latin1_General_CP1_CS_AS",<br>  "create_mode": "Default",<br>  "db_name": "sonarqubemssqldb9000",<br>  "license_type": null,<br>  "max_size_gb": 128,<br>  "min_capacity": 1,<br>  "point_in_time_restore_days": 7,<br>  "read_scale": false,<br>  "sku_name": "GP_S_Gen5_2",<br>  "storage_account_type": "Zone",<br>  "zone_redundant": false<br>}</pre> | no |
| <a name="input_mssql_fw_rules"></a> [mssql\_fw\_rules](#input\_mssql\_fw\_rules) | List of SQL firewall rules in format: [[rule1, startIP, endIP],[rule2, startIP, endIP]] etc. | `list(list(string))` | <pre>[<br>  [<br>    "AllowAll",<br>    "0.0.0.0",<br>    "0.0.0.0"<br>  ]<br>]</pre> | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | Name of the resource group where networking resources are hosted (if different from resource group hosting ACI resources). | `string` | n/a | yes |
| <a name="input_pass_length"></a> [pass\_length](#input\_pass\_length) | Password length for sql admin creds. (Stored in sonarqube key vault) | `number` | `24` | no |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | Private DNS zones to create and link to VNET. | `list(string)` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group where resources will be hosted. | `string` | n/a | yes |
| <a name="input_resource_subnet_name"></a> [resource\_subnet\_name](#input\_resource\_subnet\_name) | The name for the resource subnet, used in data source to get subnet ID. | `string` | n/a | yes |
| <a name="input_sa_config"></a> [sa\_config](#input\_sa\_config) | Storage configuration object to create persistent azure file shares for sonarqube aci. | <pre>object({<br>    name                      = string<br>    account_kind              = string<br>    account_tier              = string<br>    account_replication_type  = string<br>    access_tier               = string<br>    enable_https_traffic_only = bool<br>    min_tls_version           = string<br>    is_hns_enabled            = bool<br>  })</pre> | <pre>{<br>  "access_tier": "Hot",<br>  "account_kind": "StorageV2",<br>  "account_replication_type": "LRS",<br>  "account_tier": "Standard",<br>  "enable_https_traffic_only": true,<br>  "is_hns_enabled": false,<br>  "min_tls_version": "TLS1_2",<br>  "name": "sonarqubesa9000"<br>}</pre> | no |
| <a name="input_shares_config"></a> [shares\_config](#input\_shares\_config) | Sonarqube file shares. | <pre>list(object({<br>    share_name = string<br>    quota_gb   = number<br>  }))</pre> | <pre>[<br>  {<br>    "quota_gb": 10,<br>    "share_name": "data"<br>  },<br>  {<br>    "quota_gb": 10,<br>    "share_name": "extensions"<br>  },<br>  {<br>    "quota_gb": 10,<br>    "share_name": "logs"<br>  },<br>  {<br>    "quota_gb": 1,<br>    "share_name": "conf"<br>  }<br>]</pre> | no |
| <a name="input_sonar_config"></a> [sonar\_config](#input\_sonar\_config) | Sonarqube container configuration object to create sonarqube aci. | <pre>object({<br>    container_name                  = string<br>    container_image                 = string<br>    container_cpu                   = number<br>    container_memory                = number<br>    container_environment_variables = map(string)<br>    container_commands              = list(string)<br>  })</pre> | <pre>{<br>  "container_commands": [],<br>  "container_cpu": 2,<br>  "container_environment_variables": null,<br>  "container_image": "sonarqube:lts-community",<br>  "container_memory": 8,<br>  "container_name": "sonarqube-server"<br>}</pre> | no |
| <a name="input_sonarqube_private_dns_record"></a> [sonarqube\_private\_dns\_record](#input\_sonarqube\_private\_dns\_record) | Private dns A record for sonarqube instance. (Remember to add dns zone link to other peered vnets to resolve aci dns record.) Otherwise use hosts file to resolve the dns record for internal sonarqube instance: 'custom.domain.local'. | `string` | `"sonar"` | no |
| <a name="input_sql_admin_username"></a> [sql\_admin\_username](#input\_sql\_admin\_username) | Username for sql admin creds. (Stored in sonarqube key vault) | `string` | `"Sonar-Admin"` | no |
| <a name="input_storage_firewall_allowed_ips"></a> [storage\_firewall\_allowed\_ips](#input\_storage\_firewall\_allowed\_ips) | value of storage firewall allowed ip rules. | `list(string)` | `[]` | no |
| <a name="input_storage_firewall_bypass"></a> [storage\_firewall\_bypass](#input\_storage\_firewall\_bypass) | List of storage firewall rules to bypass. | `list(string)` | <pre>[<br>  "AzureServices"<br>]</pre> | no |
| <a name="input_storage_firewall_default_action"></a> [storage\_firewall\_default\_action](#input\_storage\_firewall\_default\_action) | Default action for storage firewall rules. | `string` | `"Deny"` | no |
| <a name="input_subnet_config"></a> [subnet\_config](#input\_subnet\_config) | A list of subnet configuration objects to create subnets in the virtual network. | <pre>list(object({<br>    subnet_name                                   = string<br>    subnet_address_space                          = list(string)<br>    service_endpoints                             = list(string)<br>    private_endpoint_network_policies_enabled     = bool<br>    private_link_service_network_policies_enabled = bool<br>  }))</pre> | `null` | no |
| <a name="input_subnet_config_delegated_aci"></a> [subnet\_config\_delegated\_aci](#input\_subnet\_config\_delegated\_aci) | A list of subnet configuration objects to create subnets in the virtual network. - delegated to ACI | <pre>list(object({<br>    subnet_name                                   = string<br>    subnet_address_space                          = list(string)<br>    service_endpoints                             = list(string)<br>    private_endpoint_network_policies_enabled     = bool<br>    private_link_service_network_policies_enabled = bool<br>    delegation_name                               = string<br>    delegation_service                            = string<br>    delegation_ations                             = list(string)<br>  }))</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key value pairs that is used to tag resources created. | `map(string)` | <pre>{<br>  "Author": "Marcel Lupo",<br>  "Description": "Sonarqube VNET integrated aci with caddy (self signed cert).",<br>  "GitHub": "https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal",<br>  "Terraform": "True"<br>}</pre> | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the virtual network where resources are attached. | `string` | `null` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | value of the address space for the virtual network. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_container_group"></a> [azurerm\_container\_group](#output\_azurerm\_container\_group) | The container group object. |
| <a name="output_azurerm_private_dns_fqdn"></a> [azurerm\_private\_dns\_fqdn](#output\_azurerm\_private\_dns\_fqdn) | The private DNS FQDN of the sonarqube instance. |
| <a name="output_sonarqube_aci_container_group_ip_address"></a> [sonarqube\_aci\_container\_group\_ip\_address](#output\_sonarqube\_aci\_container\_group\_ip\_address) | The container group IP address (Private IP of the sonarqube instance). |
| <a name="output_sonarqube_aci_kv_id"></a> [sonarqube\_aci\_kv\_id](#output\_sonarqube\_aci\_kv\_id) | The resource ID for the sonarqube key vault. |
| <a name="output_sonarqube_aci_mssql_db_id"></a> [sonarqube\_aci\_mssql\_db\_id](#output\_sonarqube\_aci\_mssql\_db\_id) | The resource ID for the sonarqube MSSQL database. |
| <a name="output_sonarqube_aci_mssql_db_name"></a> [sonarqube\_aci\_mssql\_db\_name](#output\_sonarqube\_aci\_mssql\_db\_name) | The name of the sonarqube MSSQL database. |
| <a name="output_sonarqube_aci_mssql_id"></a> [sonarqube\_aci\_mssql\_id](#output\_sonarqube\_aci\_mssql\_id) | The resource ID for the sonarqube MSSQL Server instance. |
| <a name="output_sonarqube_aci_sa_id"></a> [sonarqube\_aci\_sa\_id](#output\_sonarqube\_aci\_sa\_id) | The resource ID for the sonarqube storage account hosting file shares. |
| <a name="output_sonarqube_aci_share_ids"></a> [sonarqube\_aci\_share\_ids](#output\_sonarqube\_aci\_share\_ids) | List of resource IDs of each of the sonarqube file shares. |
<!-- END_TF_DOCS -->