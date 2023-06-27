# ##################################################
# # OUTPUTS                                        #
# ##################################################
output "sonarqube_aci_kv_id" {
  value       = azurerm_key_vault.sonarqube_kv.id
  description = "The resource ID for the sonarqube key vault."
}

output "sonarqube_aci_sa_id" {
  value       = azurerm_storage_account.sonarqube_sa.id
  description = "The resource ID for the sonarqube storage account hosting file shares."
}

output "sonarqube_aci_share_ids" {
  value       = toset([for each in azurerm_storage_share.sonarqube : each.id])
  description = "List of resource IDs of each of the sonarqube file shares."
}

output "sonarqube_aci_mssql_id" {
  value       = azurerm_mssql_server.sonarqube_mssql.id
  description = "The resource ID for the sonarqube MSSQL Server instance."
}

output "sonarqube_aci_mssql_db_id" {
  value       = azurerm_mssql_database.sonarqube_mssql_db.id
  description = "The resource ID for the sonarqube MSSQL database."
}

output "sonarqube_aci_mssql_db_name" {
  value       = azurerm_mssql_database.sonarqube_mssql_db.name
  description = "The name of the sonarqube MSSQL database."
}

output "sonarqube_aci_container_group_ip_address" {
  value       = azurerm_container_group.sonarqube_aci_private.ip_address
  description = "The container group IP address (Private IP of the sonarqube instance)."
}

output "azurerm_container_group" {
    value       = azurerm_container_group.sonarqube_aci_private
    description = "The container group object."
}

output "azurerm_private_dns_fqdn" {
    value       = var.aci_private_dns_record ? azurerm_private_dns_a_record.aci_a_record[0].fqdn : null 
    description = "The private DNS FQDN of the sonarqube instance."
}