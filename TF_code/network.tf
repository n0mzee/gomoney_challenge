resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.254.0.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.254.2.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "example-pip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Dynamic"
}

#&nbsp;since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.example.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.example.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.example.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.example.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.example.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.example.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.example.name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "example-appgateway"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}

resource "azurerm_virtual_network" "servers" {
  name                = "servers-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_lb" "api_lb" {
  name                = "api-lb"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
}

resource "azurerm_lb" "web_lb" {
  name                = "web-lb"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
}

resource "azurerm_lb_backend_address_pool" "api" {
  name            = "first"
  loadbalancer_id = azurerm_lb.api_lb.id
}

resource "azurerm_lb_backend_address_pool" "web" {
  name            = "first"
  loadbalancer_id = azurerm_lb.web_lb.id
}

resource "azurerm_lb_backend_address_pool_address" "example" {
  name                    = "example"
  backend_address_pool_id = azurerm_lb_backend_address_pool.api.id
  virtual_network_id      = azurerm_virtual_network.servers.id
  ip_address              = "10.0.0.1"
}

resource "azurerm_lb_backend_address_pool_address" "example" {
  name                    = "example"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
  virtual_network_id      = azurerm_virtual_network.servers.id
  ip_address              = "10.0.1.1"
}

# VNET PEERING CONFIGURATION

resource "azurerm_virtual_network_peering" "agw2lb" {
  name                      = "AGW to Servers"
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.example.name
  remote_virtual_network_id = azurerm_virtual_network.servers.id
}

resource "azurerm_virtual_network_peering" "lb2agw" {
  name                      = "Servers to AGW"
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.servers.name
  remote_virtual_network_id = azurerm_virtual_network.example.id
}

