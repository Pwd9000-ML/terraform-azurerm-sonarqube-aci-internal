# Automated Test 3

This terraform module only creates the SonarQube instance and supporting resources. VNET integration is done on existing network resources.  
Networking prerequisites are not created and the module requires parameters for existing VNET/Subnets and private DNS zones to be integrated into.  

In this test the module is used to create + VNET integrate ONLY the SonarQube instance and supporting resources. The parameter for creating networking resources: `"create_networking_prereqs = false"`.  

See **[Automated Test 1](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/tests/auto_test1)** for an example on how to create the networking prerequisites as separate resources, or **[Automated Test 2](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/tests/auto_test2)** for an example on how to create the networking prerequisites and SonarQube instance in one module.  

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
| [azurerm_resource_group.sonarqube_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_integer.number](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delegated_subnet_name"></a> [delegated\_subnet\_name](#input\_delegated\_subnet\_name) | The name for the aci delegated subnet, used in data source to get subnet ID. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where resources will be hosted. | `string` | `null` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | Name of the resource group where existing networking resources are hosted. | `string` | `null` | no |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | Private DNS zones for DNS VNET links. | `list(string)` | `[]` | no |
| <a name="input_resource_subnet_name"></a> [resource\_subnet\_name](#input\_resource\_subnet\_name) | The name for the resource subnet, used in data source to get subnet ID. | `string` | `null` | no |
| <a name="input_sonarqube_resource_group_name"></a> [sonarqube\_resource\_group\_name](#input\_sonarqube\_resource\_group\_name) | Name of the resource group to create where sonarqube instance resources will be hosted. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key value pairs that is used to tag resources created. | `map(string)` | `{}` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the virtual network where resources will be attached. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->