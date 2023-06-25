##################################################
# CREATE NETWORK RESOURCE PREREQUISITES.         #
##################################################
# IMPORTANT: If existing network resources exist #
# set 'var.create_networking_prereqs' = false    #
##################################################

module "private_endpoint_kv" {
  source                          = "./modules/network_prereqs"
  # Only deploy networking prereqs if 'var.create_networking_prereqs' is true
  count                       = var.create_networking_prereqs == true ? 1 : 0
  network_resource_group_name = var.network_resource_group_name
  location                    = var.location
  virtual_network_name        = var.virtual_network_name
  vnet_address_space          = var.vnet_address_space
  subnet_config               = var.subnet_config
  subnet_config_delegated_aci = var.subnet_config_delegated_aci
  private_dns_zones           = var.private_dns_zones
  tags                        = var.tags
}

###############################################################
# DEPLOY VNET INTEGRATED SONARQUBE ACI + SUPPORTING RESOURCES #
###############################################################
# IMPORTANT: If existing network resources exist only supply  #
# the relevant variables to the module below.(See ./examples) #
###############################################################
### MAIN MODULE START - DEPLOY VNET INTEGRATED SONARQUBE ACI INSTANCE - ENSURE NETWORKING PREREQS EXIST OR CREATE NEW FROM MODULE './modules/network_prereqs' ###
###Key Vault###
#Create Key Vault with RBAC model (To save SQL admin Password and Username)
resource "azurerm_key_vault" "sonarqube_kv" {
  resource_group_name       = var.resource_group_name
  location                  = var.location
  enable_rbac_authorization = true
  #values from variable kv_config object
  name      = lower(var.kv_config.name)
  sku_name  = var.kv_config.sku
  tenant_id = data.azurerm_client_config.current.tenant_id
  dynamic "network_acls" {
    for_each = local.kv_net_rules
    content {
      default_action             = network_acls.value.default_action
      bypass                     = network_acls.value.bypass
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }
  tags = var.tags
}

#Private Endpoint for keyvault
module "private_endpoint_kv" {
  source                          = "./modules/private_endpoint"
  location                        = azurerm_key_vault.sonarqube_kv.location
  resource_group_name             = azurerm_key_vault.sonarqube_kv.resource_group_name
  subnet_id                       = data.azurerm_subnet.resource_subnet.id
  private_endpoint_name           = "${azurerm_key_vault.sonarqube_kv.name}-pe"
  private_service_connection_name = "${azurerm_key_vault.sonarqube_kv.name}-pe-sc"
  private_connection_resource_id  = azurerm_key_vault.sonarqube_kv.id
  private_dns_zone_group          = local.loc_private_dns_zone_group_kv
  is_manual_connection            = false
  subresource_names               = ["Vault"]
  tags                            = var.tags
}

#Add "self" permission to key vault RBAC
resource "azurerm_role_assignment" "kv_role_assigment" {
  for_each             = toset(["Key Vault Administrator"])
  role_definition_name = each.key
  scope                = azurerm_key_vault.sonarqube_kv.id
  principal_id         = data.azurerm_client_config.current.object_id
}

###Storage Account and file shares for ACI persistent file storage.###
resource "azurerm_storage_account" "sonarqube_sa" {
  resource_group_name = var.resource_group_name
  location            = var.location
  #values from variable sa_config object
  name                      = lower(substr(var.sa_config.name, 0, 24))
  account_kind              = var.sa_config.account_kind
  account_tier              = var.sa_config.account_tier
  account_replication_type  = var.sa_config.account_replication_type
  access_tier               = var.sa_config.access_tier
  enable_https_traffic_only = var.sa_config.enable_https_traffic_only
  min_tls_version           = var.sa_config.min_tls_version
  is_hns_enabled            = var.sa_config.is_hns_enabled
  dynamic "network_rules" {
    for_each = local.sa_net_rules
    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }
  tags = var.tags
}

#Sonarqube file shares
resource "azurerm_storage_share" "sonarqube" {
  for_each             = { for each in var.shares_config : each.share_name => each }
  name                 = each.value.share_name
  quota                = each.value.quota_gb
  storage_account_name = azurerm_storage_account.sonarqube_sa.name
}
#Upload sonarqube config file
resource "azurerm_storage_share_file" "sonar_properties" {
  name             = "sonar.properties"
  storage_share_id = azurerm_storage_share.sonarqube["conf"].id
  source           = abspath("${path.module}/sonar.properties")
}

#Private Endpoint for aci storage account
module "private_endpoint_sa" {
  source                          = "./modules/private_endpoint"
  location                        = azurerm_storage_account.sonarqube_sa.location
  resource_group_name             = azurerm_storage_account.sonarqube_sa.resource_group_name
  subnet_id                       = data.azurerm_subnet.resource_subnet.id
  private_endpoint_name           = "${azurerm_storage_account.sonarqube_sa.name}-pe"
  private_service_connection_name = "${azurerm_storage_account.sonarqube_sa.name}-pe-sc"
  private_connection_resource_id  = azurerm_storage_account.sonarqube_sa.id
  private_dns_zone_group          = local.loc_private_dns_zone_group_sa
  is_manual_connection            = false
  subresource_names               = ["File"]
  tags                            = var.tags
}

### Azure SQL Server ###
#Random Password
resource "random_password" "sql_admin_password" {
  length           = var.pass_length
  special          = true
  override_special = "/@\" "
}

#Add SQL admin Password and Username to Keyvault
resource "azurerm_key_vault_secret" "password_secret" {
  name         = "sonarq-mssql-sa-password"
  value        = random_password.sql_admin_password.result
  key_vault_id = azurerm_key_vault.sonarqube_kv.id
  depends_on   = [azurerm_role_assignment.kv_role_assigment]
}

resource "azurerm_key_vault_secret" "username_secret" {
  name         = "sonarq-mssql-sa-username"
  value        = var.sql_admin_username
  key_vault_id = azurerm_key_vault.sonarqube_kv.id
  depends_on   = [azurerm_role_assignment.kv_role_assigment]
}

#Create MSSQL server instance
resource "azurerm_mssql_server" "sonarqube_mssql" {
  resource_group_name = var.resource_group_name
  location            = var.location
  #values from variable mssql_config object
  name                         = lower(var.mssql_config.name)
  version                      = var.mssql_config.version
  administrator_login          = azurerm_key_vault_secret.username_secret.value
  administrator_login_password = azurerm_key_vault_secret.password_secret.value
  tags                         = var.tags
}

#Private Endpoint for mssql server
module "private_endpoint_mssql" {
  source                          = "./modules/private_endpoint"
  location                        = azurerm_mssql_server.sonarqube_mssql.location
  resource_group_name             = azurerm_mssql_server.sonarqube_mssql.resource_group_name
  subnet_id                       = data.azurerm_subnet.resource_subnet.id
  private_endpoint_name           = "${azurerm_mssql_server.sonarqube_mssql.name}-pe"
  private_service_connection_name = "${azurerm_mssql_server.sonarqube_mssql.name}-pe-sc"
  private_connection_resource_id  = azurerm_mssql_server.sonarqube_mssql.id
  private_dns_zone_group          = local.loc_private_dns_zone_group_mssql
  is_manual_connection            = false
  subresource_names               = ["sqlServer"]
  tags                            = var.tags
}

#Set firewall to allow AzureIPs (Container instances)
resource "azurerm_mssql_firewall_rule" "sonarqube_mssql_fw_rules" {
  count            = length(var.mssql_fw_rules)
  server_id        = azurerm_mssql_server.sonarqube_mssql.id
  name             = var.mssql_fw_rules[count.index][0]
  start_ip_address = var.mssql_fw_rules[count.index][1]
  end_ip_address   = var.mssql_fw_rules[count.index][2]
}

#Enable sevice endpoint for mssql server
resource "azurerm_mssql_virtual_network_rule" "mssql_vnet_rule" {
  name      = "sql-vnet-rule"
  server_id = azurerm_mssql_server.sonarqube_mssql.id
  subnet_id = data.azurerm_subnet.resource_subnet.id
}

# ###MSSQL Database###
resource "azurerm_mssql_database" "sonarqube_mssql_db" {
  server_id = azurerm_mssql_server.sonarqube_mssql.id
  #values from variable mssql_db_config object
  name                        = lower(var.mssql_db_config.db_name)
  collation                   = var.mssql_db_config.collation
  create_mode                 = var.mssql_db_config.create_mode
  license_type                = var.mssql_db_config.license_type
  max_size_gb                 = var.mssql_db_config.max_size_gb
  min_capacity                = var.mssql_db_config.min_capacity
  auto_pause_delay_in_minutes = var.mssql_db_config.auto_pause_delay_in_minutes
  read_scale                  = var.mssql_db_config.read_scale
  sku_name                    = var.mssql_db_config.sku_name
  storage_account_type        = var.mssql_db_config.storage_account_type
  zone_redundant              = var.mssql_db_config.zone_redundant
  short_term_retention_policy {
    retention_days           = var.mssql_db_config.point_in_time_restore_days
    backup_interval_in_hours = var.mssql_db_config.backup_interval_in_hours
  }
  tags = var.tags
}

###Container Group - ACIs###
resource "azurerm_container_group" "sonarqube_aci_private" {
  resource_group_name = var.resource_group_name
  location            = var.location
  #dns_name_label      = var.aci_dns_label
  #values from variable aci_group_config object
  name            = lower(var.aci_group_config.container_group_name)
  ip_address_type = var.aci_group_config.ip_address_type
  os_type         = var.aci_group_config.os_type
  restart_policy  = var.aci_group_config.restart_policy
  tags            = var.tags

  #Sonarqube container
  container {
    name                         = var.sonar_config.container_name
    image                        = var.sonar_config.container_image
    cpu                          = var.sonar_config.container_cpu
    memory                       = var.sonar_config.container_memory
    environment_variables        = var.sonar_config.container_environment_variables
    secure_environment_variables = local.sonar_sec_vars
    commands                     = var.sonar_config.container_commands
    ports {
      port     = 9000
      protocol = "TCP"
    }
    dynamic "volume" {
      for_each = var.shares_config
      content {
        name                 = volume.value.share_name
        mount_path           = "/opt/sonarqube/${volume.value.share_name}"
        share_name           = volume.value.share_name
        storage_account_name = azurerm_storage_account.sonarqube_sa.name
        storage_account_key  = azurerm_storage_account.sonarqube_sa.primary_access_key
      }
    }
  }

  #Caddy container
  container {
    name                  = var.caddy_config.container_name
    image                 = var.caddy_config.container_image
    cpu                   = var.caddy_config.container_cpu
    memory                = var.caddy_config.container_memory
    environment_variables = var.caddy_config.container_environment_variables
    commands              = var.caddy_config.container_commands
    ports {
      port     = 443
      protocol = "TCP"
    }
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
  subnet_ids = [data.azurerm_subnet.delegated_subnet_aci.id]
  depends_on = [azurerm_storage_share_file.sonar_properties]
}

# Add private IP of ACI to private DNS zone
resource "azurerm_private_dns_a_record" "example" {
  count               = var.aci_private_dns_record ? 1 : 0
  name                = var.sonarqube_private_dns_record
  zone_name           = var.local_dns_zone_name
  resource_group_name = var.network_resource_group_name
  ttl                 = 300
  records             = ["${azurerm_container_group.sonarqube_aci_private.ip_address}"]
}