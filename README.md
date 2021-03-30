# terrafom-kong-module
Terraform Module for kong configurations. For all those who want to manage the kong configurations via terraform this module provides a sinple way to configure all the required configurations. 

This module uses https://github.com/kevholditch/terraform-provider-kong as the terraform provider. 

You can create the following kong objects using this module, along with the details on what all can be configured and their defaults.:

1. Service

| Variable Name   | Type   | Map-Key         | defaults             |
|-----------------|--------|-----------------|----------------------|
| name            | String | -               |                      |
| upstream_config | Map    | protocol        | http                 |
|                 |        | host            | ${var.name}-service" |
|                 |        | port            | 80                   |
|                 |        | path            | /                    |
|                 |        | retries         | 0                    |
|                 |        | connect_timeout | 60000                |
|                 |        | write_timeout   | 60000                |
|                 |        | read_timeout    | 60000                |

2. Route

| Variable Name | Type | Map-Key        | defaults          |
|---------------|------|----------------|-------------------|
| route_config  | Map  | paths[]        |                   |
|               |      | protocol[]     | ["http", "https"] |
|               |      | hosts          |                   |
|               |      | strip_path     | true              |
|               |      | preserve_host  | false             |
|               |      | regex_priority | 0                 |
|               |      | methods        | null              |

3. Upstreams and Targets

| Variable Name   | Type |
|-----------------|------|
| upstream_config | Map  | 

4. Plugins

| Variable Name | Type |
|---------------|------|
| plugins       | Map  | 

The user have to give only some basic details that will create all the things in the background and hence making the experience seamless. Check the below examples, that covers all the details on how to configure things in details.

## Examples

1. Create a service with / route:

```
module base-svc {
  source = "../module/"
  name   = "base-svc"
  upstream_config = {
    targets = {
      "base-svc.cluster.local:8001" = {
        weight = 100
      }
    }
  }
  route_config = {
    hosts = ["basesvc.example.com"]
    paths = {
      all_route={
        path=["/"]
      },
    }
  }
}
```

This will create a service for `basesvc.example.com` for all routes which will forward the requests to the upstream target of `base-svc.cluster.local` on port 8001. 

2. Enable a plugin, by default the module configures the plugin on service level. If you want to enable it on the route level then check example #6:

```
module base-svc {
  source = "../module/"
  name   = "base-svc"
  upstream_config = {
    targets = {
      "base-svc.cluster.local:8001" = {
        weight = 100
      }
    }
  }
  route_config = {
    hosts = ["basesvc.example.com"]
    paths = {
      all_route={
        path=["/"]
      },
    }
  }
  plugins = {
    request-termination = {
      config_json = <<EOT
      {
            "status_code": 503,
            "message": "Under Maintenance"
      }
    EOT
    }
  }
}
```
The plugin also supports a on/off switch with the `enabled=<true|false>` flag.

3. Support for multiple hosts and paths:

```
module base-svc {
  source = "../module/"
  name   = "base-svc"
  upstream_config = {
    targets = {
      "base-svc.cluster.local:8001" = {
        weight = 100
      }
    }
  }
  route_config = {
    hosts = ["basesvc.example.com", "basesvc1.example.com"]
    paths = {
      test_route={
        path=["/test"]
      },
      test1_route={
          path=["/test1"]
      }
    }
  }
}
```

4. Point service to direct endpoint instead of upstream:

```
module base-svc {
  source = "../module/"
  name   = "base-svc"
  upstream_config = {
    host = "base-svc.cluster.local"
    port = "8001"
  }
  route_config = {
    hosts = ["basesvc.example.com", "basesvc1.example.com"]
    paths = {
      test_route={
        path=["/test"]
      },
      test1_route={
          path=["/test1"]
      }
    }
  }
}
```

5. Distribute traffic amongst multiple targets:

```
module base-svc {
  source = "../module/"
  name   = "base-svc"
  upstream_config = {
    targets = {
      "base-svc.cluster.local:8001" = {
        weight = 100
      },
      "base-svc1.cluster.local:8001" = {
        weight = 100
      }
    }
  }
  route_config = {
    hosts = ["basesvc.example.com"]
    paths = {
      all_route={
        path=["/"]
      },
    }
  }
}
```

6. Configure plugins on route level, the following will enable the `request-termination` plugin only on `test_route`:

```
module base-svc {
  source = "../module/"
  name   = "base-svc"
  upstream_config = {
    targets = {
      "base-svc.cluster.local:8001" = {
        weight = 100
      }
    }
  }
  route_config = {
    hosts = ["basesvc.example.com"]
    paths = {
      all_route={
        path=["/"]
      },
      test_route= {
        path=["/"]
      },
    }
  }
  plugins = {
    request-termination = {
      route_name = ["test_route"]
      config_json = <<EOT
      {
            "status_code": 503,
            "message": "Under Maintenance"
      }
    EOT
    }
  }
}

**Note**

There are some resources that hae UNIQUE NAME conventions, and you will get an error on voilation. For example, the route have the Unique Name limitation on the global level, so no 2 routes can have the same name, even when they are part of different services.
