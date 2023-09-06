resource "kubernetes_ingress_v1" "redis_ingress" {
  # depends_on = [
  #   kubernetes_service_v1.devops_exercise_service
  # ]
  metadata {
    name = var.ingress_redis.name
  }

  spec {
    ingress_class_name = var.ingress_redis.name
    rule {
      host = var.ingress_redis.host
      http {
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

resource "kubernetes_ingress_v1" "back_ingress" {
  depends_on = [
    kubernetes_ingress_v1.redis_ingress
  ]
  metadata {
    name = var.ingress_back.name
  }

  spec {
    ingress_class_name = var.ingress_back.name
    rule {
      host = var.ingress_back.host
      http {
        path {
          backend {
            service {
              name = var.service_back.name
              port {
                number = var.ingress_back.port
              }
            }
          }
          path      = var.ingress_back.path
          path_type = var.ingress_back.path_type
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "front_ingress" {
   depends_on = [
    kubernetes_ingress_v1.redis_ingress,
    kubernetes_deployment_v1.backdep
  ]
  metadata {
    name = var.ingress_front.name
  }

  spec {
    ingress_class_name = var.ingress_front.name
    rule {
      host = var.ingress_front.host
      http {
        path {
          backend {
            service {
              name = var.service_front.name
              port {
                number = var.ingress_front.port
              }
            }
          }
          path      = var.ingress_front.path
          path_type = var.ingress_front.path_type
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "nginx_ingress" {
  depends_on = [
    kubernetes_service_v1.nginx_service
  ]
  metadata {
    name = var.ingress_nginx.name
  }

  spec {
    ingress_class_name = var.ingress_nginx.name
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
      }
    }
  }
}

