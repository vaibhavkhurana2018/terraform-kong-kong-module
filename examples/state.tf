provider "kong" {
  kong_admin_uri = "http://127.0.0.1:8001"
}

terraform {
  required_version = "0.12.20"
}