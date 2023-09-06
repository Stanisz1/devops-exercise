resource "kubernetes_deployment_v1" "redisdep" {

  metadata {
    name = var.deployment_redis.name
    labels = {
      test = var.lables_app_name
    }
  }

  spec {
    replicas = var.deployment_redis.replica_number

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }
      spec {
        container {
          image             = var.deployment_redis.container_image
          name              = var.deployment_redis.container_name
          image_pull_policy = "Always"
        
        }
      }
    }
  }
 
}
