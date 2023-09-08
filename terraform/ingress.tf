# resource "kubernetes_ingress_v1" "redis_ingress" {
#   # depends_on = [
#   #   kubernetes_service_v1.devops_exercise_service
#   # ]
#   metadata {
#     name = var.ingress_redis.name
#   }

#   spec {
#     ingress_class_name = var.ingress_redis.name
#     rule {
#       host = var.ingress_redis.host
#       http {
#         path {
#           backend {
#             service {
#               name = var.service_redis.name
#               port {
#                 number = var.ingress_redis.port
#               }
#             }
#           }
#           path      = var.ingress_redis.path
#           path_type = var.ingress_redis.path_type
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_ingress_v1" "backend_ingress" {
#   depends_on = [
#     kubernetes_service_v1.backend_service
#   ]
#   metadata {
#     name = var.ingress_backend.name
#   }

#   spec {
#     ingress_class_name = var.ingress_backend.name
#     rule {
#       host = var.ingress_backend.host
#       http {
#         path {
#           backend {
#             service {
#               name = var.service_backend.name
#               port {
#                 number = var.ingress_backend.port
#               }
#             }
#           }
#           path      = var.ingress_backend.path
#           path_type = var.ingress_backend.path_type
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_ingress_v1" "frontend_ingress" {
#    depends_on = [
#     kubernetes_service_v1.frontend_service
#   ]
#   metadata {
#     name = var.ingress_frontend.name
#   }

#   spec {
#     ingress_class_name = var.ingress_frontend.name
#     rule {
#       host = var.ingress_frontend.host
#       http {
#         path {
#           backend {
#             service {
#               name = var.service_frontend.name
#               port {
#                 number = var.ingress_frontend.port
#               }
#             }
#           }
#           path      = var.ingress_frontend.path
#           path_type = var.ingress_frontend.path_type
#         }
#       }
#     }
#   }
# }

resource "kubernetes_ingress_v1" "nginx_ingress" {
  depends_on = [
    kubernetes_service_v1.nginx_service
  ]
  wait_for_load_balancer = true
  metadata {
    name = "devops-exrsice"
  }

  spec {
    ingress_class_name = var.ingress_nginx.name
    default_backend {
      service {
              name = var.service_nginx.name
              port {
                number = var.ingress_nginx.port
              }
            }
    }
    rule {
      host = var.ingress_nginx.host
      http {
        path {
          backend {
            service {
              name = var.service_nginx.name
              port {
                number = var.ingress_nginx.port
              }
            }
          }
          path      = var.ingress_nginx.path
          path_type = var.ingress_nginx.path_type
        }

        path {
          backend {
            service {
              name = var.service_backend.name
              port {
                number = var.ingress_backend.port
              }
            }
          }
          path      = var.ingress_backend.path
          path_type = var.ingress_backend.path_type
        }

        path {
          backend {
            service {
              name = var.service_frontend.name
              port {
                number = var.ingress_frontend.port
              }
            }
          }
          path      = var.ingress_frontend.path
          path_type = var.ingress_frontend.path_type
        }

        path {
          backend {
             service {
              name = var.service_redis.name
              port {
                number = var.ingress_redis.port
              }
            }
          }
          path      = var.ingress_redis.path
          path_type = var.ingress_redis.path_type
        }
       }
      }
    }
  }
output "load_balancer_hostname" {
  value = kubernetes_ingress_v1.nginx_ingress.status.0.load_balancer.0.ingress.0.hostname
  
}

output "load_balancer_ip" {
  value = kubernetes_ingress_v1.nginx_ingress.status.0.load_balancer.0.ingress.0.ip
  
}