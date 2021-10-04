output "hello_world_load_balancer_ip" {
  value = kubernetes_service.hello_world.status[0].load_balancer[0].ingress[0].ip
}