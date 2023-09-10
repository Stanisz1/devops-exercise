resource "kubernetes_deployment_v1" "nginxdep" {

  metadata {
    name = var.deployment_nginx.name
    labels = {
      app = var.lables_app_name
    }
  }

  spec {
    replicas = var.deployment_nginx.replica_number

    selector {
      match_labels =  {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image             = var.deployment_nginx.container_image
          name              = var.deployment_nginx.container_name
          image_pull_policy = "Always"
          port {
            
            container_port =  80
          }
        }
      }
    }
  }
}
