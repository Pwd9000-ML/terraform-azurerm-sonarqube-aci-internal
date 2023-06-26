network_resource_group_name   = "Terraform-Sonarqube-internal-aci-network-t2"
sonarqube_resource_group_name = "Terraform-Sonarqube-internal-aci-t2"
location                      = "uksouth"

tags = {
  Terraform   = "True"
  Description = "Sonarqube VNET integrated aci with caddy (self signed cert)."
  Author      = "Marcel Lupo"
  GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal"
}

### Specify existing networking resources ###
virtual_network_name  = "UKS-EB-VNET"
private_dns_zones     = ["privatelink.vaultcore.azure.net", "privatelink.file.core.windows.net", "privatelink.database.windows.net", "pwd9000.local"]
resource_subnet_name  = "tf-autotest-sonarqube-resource-sub"
delegated_subnet_name = "tf-autotest-sonarqube-delegated-sub"