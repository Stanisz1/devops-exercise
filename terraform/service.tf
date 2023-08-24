resource "kubernetes_service_v1" "devops_exercise_service" {
  depends_on = [
    kubernetes_deployment_v1.devops_exercise_dep
  ]
  metadata {
    name = var.service.name
  }
  spec {
    selector = local.labels

    port {
      port        = var.service.port
      target_port = var.service.target_port
    }
  }
}
