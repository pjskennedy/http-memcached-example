job "http-memcached-example" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "3m"
    progress_deadline = "10m"
    auto_revert       = true
    canary            = 0
  }

  group "application" {
    count = 1

    ephemeral_disk {
      size = 300
    }

    task "webserver" {
      driver = "docker"

      config {
        image = "quay.io/pjsk/http-memcached-example:v1"

        port_map {
          http = 4567
        }
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10
          port  "http"{}
        }
      }

      service {
        name = "http-memcached-example"
        tags = ["webserver"]
        port = "http"

        check {
          name     = "alive"
          type     = "http"
          path     = "/health"
          method   = "GET"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
