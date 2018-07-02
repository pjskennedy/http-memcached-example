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

  group "lb" {
    count = 1

    ephemeral_disk {
      size = 200
    }

    task "haproxy" {
      driver = "docker"

      config {
        image = "quay.io/pjsk/haproxy:1.8"

        port_map {
          admin = 8880
          http  = 9000
        }
      }

      artifact {
        source      = "https://raw.githubusercontent.com/pjskennedy/http-memcached-example/master/haproxy.cfg.ctmpl"
        destination = "local/"
      }

      template {
        source        = "local/haproxy.cfg.ctmpl"
        destination   = "/local/haproxy.cfg"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10

          port "http" {
            static = "9000"
          }

          port "admin" {
            static = "8880"
          }
        }
      }
    }
  }

  group "application" {
    count = 5

    ephemeral_disk {
      size = 200
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
