variable "deployment_redis" {
  description = "Deployment-related variables_redis"
  redis = {
    app_name        = "redis"
    name            = "redis"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/redis:0.3.0"
    container_name  = "redis"
  }
}
variable "deployment_back" {
  description = "Deployment-related variables_back"
  back = {
    app_name        = "back"
    name            = "back"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/back:0.3.0"
    container_name  = "back"
  }
}
variable "deployment_front" {
  description = "Deployment-related variables_front"
  front = {
    app_name        = "front"
    name            = "front"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/front:0.3.0"
    container_name  = "front"
  }
}
variable "deployment_nginx" {
  description = "Deployment-related variables_nginx"
  nginx = {
    app_name        = "nginx"
    name            = "nginx"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/nginx:0.3.0"
    container_name  = "nginx"
  }
}


variable "service_redis" {
  description = "Service-related variables_redis"
  redis = {
    name        = "redisservice"
    port        = 6379
    target_port = 6379
  }
}
variable "service_back" {
  description = "Service-related variables_back"
  back = {
    name        = "backservice"
    port        = 4000
    target_port = 4000
  }
}
variable "service_front" {
  description = "Service-related variables_front"
  front = {
    name        = "frontservice"
    port        = 3000
    target_port = 3000
  }
}
variable "service_nginx" {
  description = "Service-related variables_nginx"
  nginx = {
    name        = "nginxservice"
    port        = 80
    target_port = 80
  }
}

variable "ingress_redis" {
  description = "Ingress-related variables"
  redis = {
    name      = "redisingress"
    host      = "redisterra.com"
    port      = 6379
  }
}

variable "ingress_back" {
  back = {
    name      = "backingress"
    host      = "backterra.com"
    port      = 4000
    path      = "/api"
    path_type = "Prefix"
  }
}
variable "ingress_front" {
  front = {
    name      = "frontingress"
    host      = "frontterra.com"
    port      =  3000
    path      = "/"
    path_type = "Prefix"
  }
}
variable "ingress_nginx" {
  nginx = {
    name      = "nginxingress"
    host      = "nginxterra.com"
    port      = 80
  }
}

variable "lables_app_name" {
  default = "devopse-exersice"
}
