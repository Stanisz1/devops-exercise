variable "deployment_redis" {
  description = "Deployment-related variables_redis"
  default  = {
    app_name        = "redis"
    name            = "redis"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/redis:0.31.0"
    container_name  = "redis"
  }
}
variable "deployment_backend" {
  description = "Deployment-related variables_backend"
  default  = {
    app_name        = "backend"
    name            = "backend"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/back:0.31.0"
    container_name  = "backend"
  }
}
variable "deployment_frontend" {
  description = "Deployment-related variables_frontend"
  default  = {
    app_name        = "frontend"
    name            = "frontend"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/front:0.31.0"
    container_name  = "frontend"
  }
}
variable "deployment_nginx" {
  description = "Deployment-related variables_nginx"
  default  = {
    app_name        = "nginx"
    name            = "nginx"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/nginx:0.31.0"
    container_name  = "nginx"
  }
}


variable "service_redis" {
  description = "Service-related variables_redis"
  default  = {
    name        = "redis"
    port        = 6379
    target_port = 6379
    labels = "redis"
    environment = "dev"
  }
}
variable "service_backend" {
  description = "Service-related variables_backend"
  default  = {
    name        = "backend"
    port        = 4000
    target_port = 4000
    labels = "backend"
    environment = "dev"
  }
}
variable "service_frontend" {
  description = "Service-related variables_frontend"
  default  = {
    name        = "frontend"
    port        = 3000
    target_port = 3000
    labels = "frontend"
    environment = "dev"
  }
}
variable "service_nginx" {
  description = "Service-related variables_nginx"
  default  = {
    name        = "nginx"
    port        = 80
    target_port = 80
  
  }
}

variable "ingress_redis" {
  description = "Ingress-related variables"
  default  = {
    name      = "redis"
    host      = "redis"
    port      = 6379
    path      = "/"
    path_type = "Prefix"
  }
}

variable "ingress_backend" {
  default  = {
    name      = "backend"
    host      = "backend"
    port      = 4000
    path      = "/"
    path_type = "Prefix"
  }
}
variable "ingress_frontend" {
  default  = {
    name      = "frontend"
    host      = "frontend"
    port      =  3000
    path      = "/"
    path_type = "Prefix"
  }
}
variable "ingress_nginx" {
  default  = {
    name      = "nginx"
    host      = "nginx"
    port      = 80
    path      = "/"
    path_type = "Prefix"
  }
}

variable "lables_app_name" {
  default = "devopse-exersice"
}
