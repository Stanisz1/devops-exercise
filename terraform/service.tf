resource "kubernetes_service_v1" "redis_service" {
  depends_on = [
    kubernetes_deployment_v1.redisdep
  ]
  metadata {
    name = var.service_redis.name
  }
  spec {
    selector = local.labels

    port {
      port        = var.service_redis.port
      target_port = var.service_redis.target_port
    }
  }
}

resource "kubernetes_service_v1" "back_service" {
  depends_on = [
    kubernetes_deployment_v1.backdep
  ]
  metadata {
    name = var.service_back.name
  }
  spec {
    selector = local.labels

    port {
      port        = var.service_back.port
      target_port = var.service_back.target_port
    }
  }
}

resource "kubernetes_service_v1" "front_service" {
  depends_on = [
    kubernetes_deployment_v1.frontdep
  ]
  metadata {
    name = var.service_front.name
  }
  spec {
    selector = local.labels

    port {
      port        = var.service_front.port
      target_port = var.service_front.target_port
    }
  }
}

resource "kubernetes_service_v1" "nginx_service" {
  depends_on = [
    kubernetes_deployment_v1.nginxdep
  ]
  metadata {
    name = var.service_nginx.name
  }
  spec {
    selector = local.labels

    port {
      port        = var.service_nginx.port
      target_port = var.service_nginx.target_port
    }
  }
}
