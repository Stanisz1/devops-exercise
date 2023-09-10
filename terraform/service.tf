resource "kubernetes_service_v1" "redis_service" {
  depends_on = [
    kubernetes_deployment_v1.redisdep
  ]
  metadata {
    name = var.service_redis.name
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.redisdep.spec.0.template.0.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = var.service_redis.port
      target_port = var.service_redis.target_port
    }
    
  }
}

resource "kubernetes_service_v1" "backend_service" {
  depends_on = [
    kubernetes_deployment_v1.backdep
  ]
  metadata {
    name = var.service_backend.name
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.backdep.spec.0.template.0.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = var.service_backend.port
      target_port = var.service_backend.target_port
    }
    
  }
}

resource "kubernetes_service_v1" "frontend_service" {
  depends_on = [
    kubernetes_deployment_v1.frontdep
  ]
  metadata {
    name = var.service_frontend.name
  }
 spec {
    selector = {
      app = kubernetes_deployment_v1.frontdep.spec.0.template.0.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = var.service_frontend.port
      target_port = var.service_frontend.target_port
    }
    
  }
}

resource "kubernetes_service_v1" "nginx_service" {

  metadata {
    name = var.service_nginx.name
  }
   spec {
    selector = {
      app = kubernetes_deployment_v1.nginxdep.spec.0.template.0.metadata.0.labels.app
    }
 
    session_affinity = "ClientIP"
    port {
      port        = var.service_nginx.port
      target_port = var.service_nginx.target_port
    }
  }
}
