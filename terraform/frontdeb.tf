resource "kubernetes_deployment_v1" "frontdep" {


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
          #  env {
          #   name  = "BACKEND_API_URL"
          #   value = "http://backend"  
          # }
          # env {
          #   name  = "CLIENT_API_URL"
          #   value = "http//frontend"  
          # }
          port {
            
            container_port =  3000
          
          }
        }
      }
    }
  }
}