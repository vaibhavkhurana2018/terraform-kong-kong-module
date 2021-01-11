resource "kong_service" "service" {
  name            = var.name
  protocol        = lookup(var.upstream_config, "protocol", "http")
  host            = "${var.name}.service"
  port            = lookup(var.upstream_config, "port", 80)
  path            = lookup(var.upstream_config, "path", "/")
  retries         = lookup(var.upstream_config, "retries", 0)
  connect_timeout = lookup(var.upstream_config, "connect_timeout", 60000)
  write_timeout   = lookup(var.upstream_config, "write_timeout", 6000000)
  read_timeout    = lookup(var.upstream_config, "read_timeout", 6000000)
}
