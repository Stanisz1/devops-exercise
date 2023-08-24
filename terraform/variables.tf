variable "deployment" {
  description = "Deployment-related variables"
  redis = {
    app_name        = "redis"
    name            = "redis"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/redis:0.3.0"
    container_name  = "redis"
  }

  back = {
    app_name        = "back"
    name            = "back"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/back:0.3.0"
    container_name  = "back"
  }

  front = {
    app_name        = "front"
    name            = "front"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/front:0.3.0"
    container_name  = "front"
  }

  nginx = {
    app_name        = "nginx"
    name            = "nginx"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/nginx:0.3.0"
    container_name  = "nginx"
  }


}

variable "service" {
  description = "Service-related variables"
  redis = {
    name        = "redisservice"
    port        = 6379
    target_port = 6379
  }
  back = {
    name        = "backservice"
    port        = 4000
    target_port = 4000
  }
  front = {
    name        = "frontservice"
    port        = 3000
    target_port = 3000
  }
  nginx = {
    name        = "nginxservice"
    port        = 80
    target_port = 80
  }
}

variable "ingress" {
  description = "Ingress-related variables"
  redis = {
    name      = "redisingress"
    host      = "redisterra.com"
    port      = 6379
  }
  back = {
    name      = "backingress"
    host      = "backterra.com"
    port      = 4000
    path      = "/api"
    path_type = "Prefix"
  }
  front = {
    name      = "frontingress"
    host      = "frontterra.com"
    port      =  3000
    path      = "/"
    path_type = "Prefix"
  }
  nginx = {
    name      = "nginxingress"
    host      = "nginxterra.com"
    port      = 80
  }
}

variable "lables_app_name" {
  default = "latest"
}
