terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }
  backend "kubernetes" {
    secret_suffix = "state"
    config_path   = "~/.kube/config"
    namespace     = "kube-system"
  }
}

provider "kubernetes" {
  config_context_cluster   = "minikube"
  config_path = "~/.kube/config"
}
# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }

# resource "helm_release" "nginx_ingress_controller" {
#   name             = "nginx-ingress-controller"
#   repository       = "https://kubernetes.github.io/ingress-nginx"
#   chart            = "ingress-nginx"
#   version          = "4.1.3"
#   namespace        = "ingress"
#   create_namespace = "true"

#   set {
#     name  = "controller.service.type"
#     value = "LoadBalancer"
#   }
#   set {
#     name  = "controller.autoscaling.enabled"
#     value = "true"
#   }
#   set {
#     name  = "controller.autoscaling.minReplicas"
#     value = "2"
#   }
#   set {
#     name  = "controller.autoscaling.maxReplicas"
#     value = "10"
#   }
# }


