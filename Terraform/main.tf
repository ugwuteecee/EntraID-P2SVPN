resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

data "azurerm_log_analytics_workspace" "main" {
  name                = "log-observability-dev"
  resource_group_name = "rg-observability-dev"
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  name                       = "diag-${var.application_name}-${var.environment_name}"
  target_resource_id         = azurerm_virtual_network.main.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.main.id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

