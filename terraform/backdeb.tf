resource "kubernetes_deployment_v1" "backdep" {



  metadata {
    name = var.deployment_backend.name
    labels = {
      test = var.lables_app_name
    }
  }

  spec {
    replicas = var.deployment_backend.replica_number

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
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
          }
        }
      }
    }
  }
}

