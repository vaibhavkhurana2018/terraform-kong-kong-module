resource "kong_route" "route" {
  name           = var.name
  protocols      = lookup(var.route_config, "protocol", ["http", "https"])
  hosts          = lookup(var.route_config, "hosts")
  paths          = lookup(var.route_config, "paths", ["/"])
  strip_path     = lookup(var.route_config, "strip_path", true)
  preserve_host  = lookup(var.route_config, "preserve_host", false)
  service_id     = kong_service.service.id
  regex_priority = lookup(var.route_config, "regex_priority", 0)
}
