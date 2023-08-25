resource "kubernetes_deployment_v1" "backdep" {

  metadata {
    name = var.deployment_back.name
    labels = {
      test = var.lables_app_name
    }
  }

  spec {
    replicas = var.deployment_back.replica_number

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }
      spec {
        container {
          image             = var.deployment_back.container_image
          name              = var.deployment_back.container_name
          image_pull_policy = "Always"
        }
      }
    }
  }
}