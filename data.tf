##################################################
# DATA                                           #
##################################################
data "azurerm_client_config" "current" {}

#Data sources to get Subnet IDs
data "azurerm_subnet" "resource_subnet" {
  name                 = var.resource_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.network_resource_group_name
  depends_on           = [module.create_networking_prereqs]
}

data "azurerm_subnet" "delegated_subnet_aci" {
  name                 = var.delegated_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.network_resource_group_name
  depends_on           = [module.create_networking_prereqs]
}

#Data sources to get private dns zone Ids
data "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.network_resource_group_name
  depends_on          = [azurerm_key_vault.sonarqube_kv]
}

data "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.network_resource_group_name
  depends_on          = [azurerm_storage_account.sonarqube_sa]
}

data "azurerm_private_dns_zone" "mssql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.network_resource_group_name
  depends_on          = [azurerm_mssql_server.sonarqube_mssql]
}