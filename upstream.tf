resource "kong_upstream" "upstream" {
  name = "${var.name}-service"
  slots = 10000
}

resource "kong_target" "target" {
  for_each    = lookup(var.upstream_config, "targets")
  target      = each.key
  weight      = try(each.value.weight, 100)
  upstream_id = kong_upstream.upstream.id
}
