# Automated Test 1

This terraform module test creates virtual network prerequisites with subnets and private DNS zones setup for use with SonarQube.  
Networking prerequisites are created as separate resources to the SonarQube instance to allow for reuse of the networking resources.  
In this test the module is used to create the networking prerequisites for SonarQube as separate resources and then the SonarQube instance is created using the module.  

See **[Automated Test 2](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/tests/auto_test2)** for an example of how to create the networking prerequisites and SonarQube instance in one module by setting the parameter: `"create_networking_prereqs = true"`.  

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
| <a name="input_location"></a> [location](#input\_location) | Azure region where resources will be hosted. | `string` | `"uksouth"` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | Name of the resource group to create where sonarqube networking resources will be hosted. | `string` | n/a | yes |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | Private DNS zones to create. | `list(string)` | `[]` | no |
| <a name="input_sonarqube_resource_group_name"></a> [sonarqube\_resource\_group\_name](#input\_sonarqube\_resource\_group\_name) | Name of the resource group to create where sonarqube instance resources will be hosted. | `string` | n/a | yes |
| <a name="input_subnet_config"></a> [subnet\_config](#input\_subnet\_config) | A list of subnet configuration objects to create subnets in the virtual network. | <pre>list(object({<br>    subnet_name                                   = string<br>    subnet_address_space                          = list(string)<br>    service_endpoints                             = list(string)<br>    private_endpoint_network_policies_enabled     = bool<br>    private_link_service_network_policies_enabled = bool<br>  }))</pre> | `[]` | no |
| <a name="input_subnet_config_delegated_aci"></a> [subnet\_config\_delegated\_aci](#input\_subnet\_config\_delegated\_aci) | A list of subnet configuration objects to create subnets in the virtual network. - delegated to ACI | <pre>list(object({<br>    subnet_name                                   = string<br>    subnet_address_space                          = list(string)<br>    service_endpoints                             = list(string)<br>    private_endpoint_network_policies_enabled     = bool<br>    private_link_service_network_policies_enabled = bool<br>    delegation_name                               = string<br>    delegation_service                            = string<br>    delegation_ations                             = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key value pairs that is used to tag resources created. | `map(string)` | `{}` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the virtual network to create. | `string` | `null` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | value of the address space for the virtual network. | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->