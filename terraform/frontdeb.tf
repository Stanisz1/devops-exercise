resource "kubernetes_deployment_v1" "frontdep" {

  metadata {
    name = var.deployment_front.name
    labels = {
      test = var.lables_app_name
    }
  }

  spec {
    replicas = var.deployment_front.replica_number

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }
      spec {
        container {
          image             = var.deployment_front.container_image
          name              = var.deployment_front.container_name
          image_pull_policy = "Always"
        }
      }
    }
  }
}