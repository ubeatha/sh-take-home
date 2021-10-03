resource "kubernetes_service" "hello_world" {
  metadata {
    name = "hello-world"
  }
  spec {
    selector = {
      app = "hello-world"
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "hello_world" {
  metadata {
    name = "hello-word"
    labels = {
      name = "hello-world"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "hello-world"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-world"
        }
      }

      spec {
        container {
          image = "training/webapp:latest"
          name  = "hello-world"

          resources {
            requests = {
              cpu    = "100m"
              memory = "50M"
            }

            limits = {
              cpu    = "200m"
              memory = "100M"
            }
          }

          liveness_probe {
            tcp_socket {
              port = 5000
              }

            initial_delay_seconds = 5
            period_seconds        = 20
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "my" {
  metadata {
    name = "hello-world"
  }

  spec {
    max_replicas = 4
    min_replicas = 2

    scale_target_ref {
      kind = "Deployment"
      name = "hello-world"
    }

    target_cpu_utilization_percentage = "85"
  }
}