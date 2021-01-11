resource "kong_upstream" "api_service" {
  name = "${var.name}.service"
}

resource "kong_target" "target" {
  for_each    = lookup(var.upstream_config, "targets")
  target      = each.key
  weight      = try(each.value.weight, 100)
  upstream_id = kong_upstream.api_service.id
}