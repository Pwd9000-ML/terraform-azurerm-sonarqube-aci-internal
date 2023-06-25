network_resource_group_name   = "Terraform-Sonarqube-internal-aci-network"
sonarqube_resource_group_name = "Terraform-Sonarqube-internal-aci"
location                      = "uksouth"
tags = {
  Terraform   = "True"
  Description = "Sonarqube VNET integrated aci with caddy (self signed cert)."
  Author      = "Marcel Lupo"
  GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal"
}
