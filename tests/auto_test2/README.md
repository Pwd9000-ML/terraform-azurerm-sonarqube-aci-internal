# Automated Test 2

This terraform module test creates virtual network prerequisites with subnets and private DNS zones setup for use with SonarQube.  
Networking prerequisites are created as separate resources to the SonarQube instance to allow for reuse of the networking resources.  
In this test the module is used to create the networking prerequisites and SonarQube instance in one module by setting the parameter: `"create_networking_prereqs = true"`.  

See **Automated Test 1** for an example of how to create the networking prerequisites as separate resources by setting the parameter: `"create_networking_prereqs = false"`.  

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
| [azurerm_resource_group.sonarqube_vnet_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_integer.number](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Azure region where resources will be hosted. | `string` | `null` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | Name of the resource group to create where sonarqube networking resources will be hosted. | `string` | `null` | no |
| <a name="input_sonarqube_resource_group_name"></a> [sonarqube\_resource\_group\_name](#input\_sonarqube\_resource\_group\_name) | Name of the resource group to create where sonarqube instance resources will be hosted. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key value pairs that is used to tag resources created. | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->