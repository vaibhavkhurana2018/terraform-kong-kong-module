resource "kong_plugin" "plugin" {
  for_each    = var.plugins
  name        = try(each.value.plugin_name, each.key)
  enabled     = try(each.value.enabled, true)
  service_id  = kong_service.service.id
  route_id    = length(try(each.value.route_name, "")) > 0 ? kong_route.route[each.value.route_name].id : null
  config_json = try(each.value.config_json, null)
}
