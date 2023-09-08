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

# resource "kubernetes_deployment" "nginx" {
#   metadata {
#     name = "nginx"
#     labels = {
#       App = "ScalableNginxExample"
#     }
#   }

#   spec {
#     replicas = 2
#     selector {
#       match_labels = {
#         App = "ScalableNginxExample"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           App = "ScalableNginxExample"
#         }
#       }
#       spec {
#         container {
#           image = "nginx:1.7.8"
#           name  = "example"

#           port {
#             container_port = 80
#           }
#           }
#         }
#       }
#     }
#   }



# #  Service





# resource "kubernetes_service" "nginx-svc" {
#   metadata {
#     name = "nginx-svc"
   
#   }
#   spec {
   
#     port {
#       node_port   = 30201
#       port        = 80
#       target_port = 80
#     }

#     type = "NodePort"
#   }
# }
