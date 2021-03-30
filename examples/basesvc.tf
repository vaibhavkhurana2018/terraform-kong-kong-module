module base-svc {
  source = "vaibhavkhurana2018/kong-module/kong"
  name   = "base-svc"
  upstream_config = {
    targets = {
      "base-svc.cluster.local:8001" = {
        weight = 100
      }
    }
  }
  route_config = {
    hosts = ["basesvc.example.com", "base1.svc.example.com"]
    paths = {
      all_route={
        path=["/"]
      },
    }
  }
}
