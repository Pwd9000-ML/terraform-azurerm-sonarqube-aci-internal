locals {
  ## sonarqube secure environment variables ##
  sonar_sec_vars = {
    SONARQUBE_JDBC_URL      = "jdbc:sqlserver://${azurerm_mssql_server.sonarqube_mssql.name}.database.windows.net:1433;database=${azurerm_mssql_database.sonarqube_mssql_db.name};user=${azurerm_key_vault_secret.username_secret.value}@${azurerm_mssql_server.sonarqube_mssql.name};password=${azurerm_key_vault_secret.password_secret.value};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
    SONARQUBE_JDBC_USERNAME = azurerm_key_vault_secret.username_secret.value
    SONARQUBE_JDBC_PASSWORD = azurerm_key_vault_secret.password_secret.value
  }

  ## locals config for key vault private endpoint ##
  loc_private_dns_zone_group_kv = [{
    enabled              = true
    name                 = "privatelink.vaultcore.azure.net"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.keyvault.id]
  }]

   ## locals config for key vault private endpoint ##
  loc_private_dns_zone_group_sa = [{
    enabled              = true
    name                 = "privatelink.file.core.windows.net"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storage.id]
  }]
}