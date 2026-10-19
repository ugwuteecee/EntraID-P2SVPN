data "azurerm_key_vault" "main" {
  name                = "kv-devops-dev-rqu"
  resource_group_name = "rg-devops-dev"
}

resource "azurerm_key_vault_secret" "ginika" {
  name         = "ginika-password"
  value        = var.ginika_password
  key_vault_id = data.azurerm_key_vault.main.id
}

resource "azuread_user" "ginika" {
  user_principal_name = "gugwu@ugwuteecee.com"
  display_name        = "Ginika Ugwu"
  mail_nickname       = "gugwu"
  password            = azurerm_key_vault_secret.ginika.value # this needs to be secret
}

data "azuread_user" "chidubem" {
  user_principal_name = "cugwu@ugwuteecee.com"
}

resource "azuread_group" "vpn" {
  display_name     = "vpn access"
  security_enabled = true
}

resource "azuread_group_member" "ginika" {
  group_object_id  = azuread_group.vpn.object_id
  member_object_id = azuread_user.ginika.object_id
}

resource "azuread_group_member" "chidubem" {
  group_object_id  = azuread_group.vpn.object_id
  member_object_id = data.azuread_user.chidubem.object_id
}

