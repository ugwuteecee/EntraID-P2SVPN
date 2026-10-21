resource "azurerm_public_ip" "pip-vm1" {
  name                = "pip-${var.application_name}-${var.environment_name}-vm1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic-vm1" {
  name                = "nic-${var.application_name}-${var.environment_name}-vm1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.pip-vm1.id
  }
}

resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "azurerm_key_vault" "main" {
  name                = "kv-devops-dev-rqu"
  resource_group_name = "rg-devops-dev"
}

# To transfer the private key as a secret in KeyVault
resource "azurerm_key_vault_secret" "vm1-ssh-private" {
  name         = "vm1-ssh-private"
  value        = tls_private_key.vm1.private_key_pem
  key_vault_id = data.azurerm_key_vault.main.id
}

# To transfer the public key as a secret in KeyVault
resource "azurerm_key_vault_secret" "vm1-ssh-public" {
  name         = "vm1-ssh-public"
  value        = tls_private_key.vm1.public_key_openssh
  key_vault_id = data.azurerm_key_vault.main.id
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm1${var.application_name}${var.environment_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_D2als_v6"
  admin_username      = "adminteecee"
  network_interface_ids = [
    azurerm_network_interface.nic-vm1.id,
  ]

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = "adminteecee"
    public_key = tls_private_key.vm1.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "main" {
  virtual_machine_id = azurerm_linux_virtual_machine.vm1.id
  location           = azurerm_resource_group.main.location
  enabled            = true

  daily_recurrence_time = "2100"
  timezone              = "W. Central Africa Standard Time"

  notification_settings {
    enabled         = true
    time_in_minutes = 30
    email           = "<email address>"
  }
}

resource "azurerm_virtual_machine_extension" "entra-id-login" {
  name                       = "${azurerm_linux_virtual_machine.vm1.name}-AADSSHLogin"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm1.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

data "azuread_group" "vpn" {
  display_name     = "vpn access"
  security_enabled = true
}

resource "azurerm_role_assignment" "entra-id-user" {
  scope                = azurerm_linux_virtual_machine.vm1.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = data.azuread_group.vpn.object_id
}

data "azuread_group" "network" {
  display_name     = "Network Department"
  security_enabled = true
}

resource "azurerm_role_assignment" "entra-id-user" {
  scope                = azurerm_linux_virtual_machine.vm1.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = data.azuread_group.network.object_id
}

