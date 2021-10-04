resource "kubernetes_service" "hello_world" {
  metadata {
    name      = "hello-world"
    namespace = "prod"
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
    name      = "hello-word"
    namespace = "prod"
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

resource "kubernetes_horizontal_pod_autoscaler" "hello_world" {
  metadata {
    name      = "hello-world"
    namespace = "prod"
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

// Network deny policy had no effect on service
// resource "kubernetes_network_policy" "default-deny-ingress" {
//   metadata {
//     name = "default-deny-ingress"
//     namespace = "prod"
//   }

//   spec {
//     pod_selector {}
//     policy_types = ["Ingress"]
//   }
// }

// resource "kubernetes_network_policy" "hello_world" {
//   metadata {
//     name      = "hello-word-network-policy"
//     namespace = "prod"
//   }

//   spec {
//     pod_selector {
//       match_expressions {
//         key      = "name"
//         operator = "In"
//         values   = ["hello-world"]
//       }
//     }

//     ingress {
//       ports {
//         port     = "http"
//         protocol = "TCP"
//       }
//     }

//     egress {} # single empty rule to allow all egress traffic

//     policy_types = ["Ingress", "Egress"]
//   }
// }