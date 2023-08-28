variable "deployment_redis" {
  description = "Deployment-related variables_redis"
  default  = {
    app_name        = "redis"
    name            = "redis"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/redis:0.8.0"
    container_name  = "redis"
  }
}
variable "deployment_back" {
  description = "Deployment-related variables_back"
  default  = {
    app_name        = "back"
    name            = "back"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/back:0.8.0"
    container_name  = "back"
  }
}
variable "deployment_front" {
  description = "Deployment-related variables_front"
  default  = {
    app_name        = "front"
    name            = "front"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/front:0.8.0"
    container_name  = "front"
  }
}
variable "deployment_nginx" {
  description = "Deployment-related variables_nginx"
  default  = {
    app_name        = "nginx"
    name            = "nginx"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/nginx:0.8.0"
    container_name  = "nginx"
  }
}


variable "service_redis" {
  description = "Service-related variables_redis"
  default  = {
    name        = "redisservice"
    port        = 6379
    target_port = 6379
  }
}
variable "service_back" {
  description = "Service-related variables_back"
  default  = {
    name        = "backservice"
    port        = 4000
    target_port = 4000
  }
}
variable "service_front" {
  description = "Service-related variables_front"
  default  = {
    name        = "frontservice"
    port        = 3000
    target_port = 3000
  }
}
variable "service_nginx" {
  description = "Service-related variables_nginx"
  default  = {
    name        = "nginxservice"
    port        = 80
    target_port = 80
  }
}

variable "ingress_redis" {
  description = "Ingress-related variables"
  default  = {
    name      = "redisingress"
    host      = "redisterra.com"
    port      = 6379
    path      = "/"
    path_type = "Prefix"
  }
}

variable "ingress_back" {
  default  = {
    name      = "backingress"
    host      = "backterra.com"
    port      = 4000
    path      = "/"
    path_type = "Prefix"
  }
}
variable "ingress_front" {
  default  = {
    name      = "frontingress"
    host      = "frontterra.com"
    port      =  3000
    path      = "/"
    path_type = "Prefix"
  }
}
variable "ingress_nginx" {
  default  = {
    name      = "nginxingress"
    host      = "nginxterra.com"
    port      = 80
    path      = "/"
    path_type = "Prefix"
  }
}

variable "lables_app_name" {
  default = "devopse-exersice"
}
