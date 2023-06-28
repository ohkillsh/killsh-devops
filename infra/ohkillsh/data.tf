data "azurerm_key_vault" "global_kv" {
  name                = var.global_key_vault_name
  resource_group_name = var.global_resource_group

  depends_on = [module.aks]
}

data "azurerm_key_vault_secret" "acr_login" {
  name         = "acr-base-login"
  key_vault_id = data.azurerm_key_vault.global_kv.id

  depends_on = [data.azurerm_key_vault.global_kv]
}

data "azurerm_key_vault_secret" "acr_url" {
  name         = "acr-base-url"
  key_vault_id = data.azurerm_key_vault.global_kv.id

  depends_on = [data.azurerm_key_vault.global_kv]
}

data "azurerm_key_vault_secret" "acr_password" {
  name         = "acr-base-password"
  key_vault_id = data.azurerm_key_vault.global_kv.id

  depends_on = [data.azurerm_key_vault.global_kv]
}

data "azurerm_key_vault_secret" "tf-client-id" {
  name         = "tf-client-id"
  key_vault_id = data.azurerm_key_vault.global_kv.id

  depends_on = [data.azurerm_key_vault.global_kv]
}

data "azurerm_key_vault_secret" "tf-client-secret" {
  name         = "tf-client-secret"
  key_vault_id = data.azurerm_key_vault.global_kv.id

  depends_on = [data.azurerm_key_vault.global_kv]
}

data "azurerm_key_vault_secret" "tf-tenant-id" {
  name         = "tf-tenant-id"
  key_vault_id = data.azurerm_key_vault.global_kv.id

  depends_on = [data.azurerm_key_vault.global_kv]
}
