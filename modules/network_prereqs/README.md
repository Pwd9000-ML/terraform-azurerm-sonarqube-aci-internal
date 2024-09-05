# Create Networking Prerequisites

This sub module will create the networking prerequisites for SonarQube.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone.private_dns_zones](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet-link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_subnet.resource_subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.sonarqube_sub_del](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.sonarqube_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Azure region where resources will be hosted. | `string` | `"uksouth"` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | Name of the resource group to where networking resources will be hosted. | `string` | n/a | yes |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | Private DNS zones to create and link to VNET. | `list(string)` | <pre>[<br>  "privatelink.vaultcore.azure.net",<br>  "privatelink.file.core.windows.net",<br>  "privatelink.database.windows.net",<br>  "pwd9000.local"<br>]</pre> | no |
| <a name="input_subnet_config"></a> [subnet\_config](#input\_subnet\_config) | A list of subnet configuration objects to create subnets in the virtual network. | <pre>list(object({<br>    subnet_name                                   = string<br>    subnet_address_space                          = list(string)<br>    service_endpoints                             = list(string)<br>    private_endpoint_network_policies_enabled     = string<br>    private_link_service_network_policies_enabled = bool<br>  }))</pre> | <pre>[<br>  {<br>    "private_endpoint_network_policies_enabled": "Enabled",<br>    "private_link_service_network_policies_enabled": false,<br>    "service_endpoints": [<br>      "Microsoft.Storage",<br>      "Microsoft.Sql",<br>      "Microsoft.KeyVault"<br>    ],<br>    "subnet_address_space": [<br>      "10.3.0.0/24"<br>    ],<br>    "subnet_name": "sonarqube-resource-sub"<br>  }<br>]</pre> | no |
| <a name="input_subnet_config_delegated_aci"></a> [subnet\_config\_delegated\_aci](#input\_subnet\_config\_delegated\_aci) | A list of subnet configuration objects to create subnets in the virtual network. - delegated to ACI | <pre>list(object({<br>    subnet_name                                   = string<br>    subnet_address_space                          = list(string)<br>    service_endpoints                             = list(string)<br>    private_endpoint_network_policies_enabled     = string<br>    private_link_service_network_policies_enabled = bool<br>    delegation_name                               = string<br>    delegation_service                            = string<br>    delegation_ations                             = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "delegation_ations": [<br>      "Microsoft.Network/virtualNetworks/subnets/action"<br>    ],<br>    "delegation_name": "aci-sub-delegation",<br>    "delegation_service": "Microsoft.ContainerInstance/containerGroups",<br>    "private_endpoint_network_policies_enabled": "Enabled",<br>    "private_link_service_network_policies_enabled": false,<br>    "service_endpoints": [],<br>    "subnet_address_space": [<br>      "10.3.1.0/24"<br>    ],<br>    "subnet_name": "sonarqube-delegated-sub"<br>  }<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key value pairs that is used to tag resources created. | `map(string)` | <pre>{<br>  "Author": "Marcel Lupo",<br>  "Description": "Sonarqube Private Networking Resource.",<br>  "GitHub": "https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal",<br>  "Terraform": "True"<br>}</pre> | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the virtual network to create. | `string` | `"sonarqube-vnet"` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | value of the address space for the virtual network. | `list(string)` | <pre>[<br>  "10.3.0.0/16"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_delegated_subnets"></a> [delegated\_subnets](#output\_delegated\_subnets) | output the delegated subnet objects. |
| <a name="output_private_dns_zone_vnet_links"></a> [private\_dns\_zone\_vnet\_links](#output\_private\_dns\_zone\_vnet\_links) | output the private dns zone vnet link objects. |
| <a name="output_private_dns_zones"></a> [private\_dns\_zones](#output\_private\_dns\_zones) | output the private dns zone objects. |
| <a name="output_resource_subnets"></a> [resource\_subnets](#output\_resource\_subnets) | output the resource subnet objects. |
| <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space) | The address space of the sonarqube virtual network. |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | The resource ID for the sonarqube virtual network. |
<!-- END_TF_DOCS -->