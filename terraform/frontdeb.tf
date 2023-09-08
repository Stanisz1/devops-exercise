resource "kubernetes_deployment_v1" "frontdep" {
  # depends_on = [
  #   kubernetes_deployment_v1.backdep,
  #   kubernetes_deployment_v1.redisdeb
  # ]



  metadata {
    name = var.deployment_frontend.name
    labels = {
      app = var.lables_app_name
    }
  }

  spec {
    replicas = var.deployment_frontend.replica_number

    selector {
      match_labels =  {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }
      spec {
        container {
          image             = var.deployment_frontend.container_image
          name              = var.deployment_frontend.container_name
          image_pull_policy = "Always"
           env {
            name  = "BACKEND_API_URL"
            value = "http://backend"  # Update this with the actual Back service name and port
          }
          env {
            name  = "CLIENT_API_URL"
            value = "http//frontend"  # Update this with the actual Back service name and port
          }
          port {
            
            container_port =  3000
            # target_port = 3000
          }
        }
      }
    }
  }
}