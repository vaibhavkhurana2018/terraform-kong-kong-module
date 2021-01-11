resource "kong_plugin" "plugin" {
  for_each    = var.plugins
  name        = each.key
  enabled     = try(each.value.enabled, true)
  service_id  = kong_service.service.id
  config_json = try(each.value.config_json, null)
}
