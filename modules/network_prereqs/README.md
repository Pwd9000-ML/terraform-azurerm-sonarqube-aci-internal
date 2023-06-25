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
| <a name="input_subnet_config"></a> [subnet\_config](#input\_subnet\_config) | A list of subnet configuration objects to create subnets in the virtual network. | <pre>list(object({<br>    subnet_name                                   = string<br>    subnet_address_space                          = list(string)<br>    service_endpoints                             = list(string)<br>    private_endpoint_network_policies_enabled     = bool<br>    private_link_service_network_policies_enabled = bool<br>  }))</pre> | <pre>[<br>  {<br>    "private_endpoint_network_policies_enabled": false,<br>    "private_link_service_network_policies_enabled": false,<br>    "service_endpoints": [<br>      "Microsoft.Storage",<br>      "Microsoft.Sql",<br>      "Microsoft.KeyVault"<br>    ],<br>    "subnet_address_space": [<br>      "10.3.0.0/24"<br>    ],<br>    "subnet_name": "sonarqube-resource-sub"<br>  }<br>]</pre> | no |
| <a name="input_subnet_config_delegated_aci"></a> [subnet\_config\_delegated\_aci](#input\_subnet\_config\_delegated\_aci) | A list of subnet configuration objects to create subnets in the virtual network. - delegated to ACI | <pre>list(object({<br>    subnet_name                                   = string<br>    subnet_address_space                          = list(string)<br>    service_endpoints                             = list(string)<br>    private_endpoint_network_policies_enabled     = bool<br>    private_link_service_network_policies_enabled = bool<br>    delegation_name                               = string<br>    delegation_service                            = string<br>    delegation_ations                             = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "delegation_ations": [<br>      "Microsoft.Network/virtualNetworks/subnets/action"<br>    ],<br>    "delegation_name": "aci-sub-delegation",<br>    "delegation_service": "Microsoft.ContainerInstance/containerGroups",<br>    "private_endpoint_network_policies_enabled": false,<br>    "private_link_service_network_policies_enabled": false,<br>    "service_endpoints": [],<br>    "subnet_address_space": [<br>      "10.3.1.0/24"<br>    ],<br>    "subnet_name": "sonarqube-delegated-sub"<br>  }<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key value pairs that is used to tag resources created. | `map(string)` | <pre>{<br>  "Author": "Marcel Lupo",<br>  "Description": "Sonarqube Internal Network.",<br>  "GitHub": "https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal",<br>  "Terraform": "True"<br>}</pre> | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the virtual network to create. | `string` | `"sonarqube-vnet"` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | value of the address space for the virtual network. | `list(string)` | <pre>[<br>  "10.3.0.0/16"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_delegated_subnet_address_prefix"></a> [delegated\_subnet\_address\_prefix](#output\_delegated\_subnet\_address\_prefix) | The address prefix of the sonarqube delegated subnet. |
| <a name="output_delegated_subnet_id"></a> [delegated\_subnet\_id](#output\_delegated\_subnet\_id) | The resource ID for the sonarqube delegated subnet. |
| <a name="output_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#output\_private\_dns\_zone\_ids) | The ids of the sonarqube private dns zones. |
| <a name="output_private_dns_zone_vnet_link_ids"></a> [private\_dns\_zone\_vnet\_link\_ids](#output\_private\_dns\_zone\_vnet\_link\_ids) | The ids of the sonarqube private dns zone vnet links. |
| <a name="output_resource_subnet_address_prefix"></a> [resource\_subnet\_address\_prefix](#output\_resource\_subnet\_address\_prefix) | The address prefix of the sonarqube resource subnet. |
| <a name="output_resource_subnet_id"></a> [resource\_subnet\_id](#output\_resource\_subnet\_id) | The resource ID for the sonarqube resource subnet. |
| <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space) | The address space of the sonarqube virtual network. |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | The resource ID for the sonarqube virtual network. |
<!-- END_TF_DOCS -->