resource "kubernetes_deployment_v1" "backdep" {

  metadata {
    name = var.deployment_backend.name
  
  }

  spec {
    replicas = var.deployment_backend.replica_number

    selector {
      match_labels =  {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }
      spec {
        container {
          image             = var.deployment_backend.container_image
          name              = var.deployment_backend.container_name
          image_pull_policy = "Always"
          env {
            name  = "REDIS_SERVER"
            value = "redis:6379" 
          }
          port {
            
            container_port =  4000
            # target_port = 4000
          }
        }
      }
    }
  }
}

