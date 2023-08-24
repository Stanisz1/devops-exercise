variable "deployment" {
  description = "Deployment-related variables"
  default = {
    app_name        = "devops_exercise_"
    name            = "devops_exercise_"
    replica_number  = 1
    container_image = "ghcr.io/stanisz1/devops_exercise_:ace07b74b63cab357e1623f20a19ccf99b6ad187"
    container_name  = "devops_exercise_"
  }
}

variable "service" {
  description = "Service-related variables"
  default = {
    name        = "devops_exercise_service"
    port        = 80
    target_port = 80
  }
}

variable "ingress" {
  description = "Ingress-related variables"
  default = {
    name      = "devops_exercise_ingress"
    host      = "devops_exercise_terraformhw.com"
    port      = 80
    path      = "/"
    path_type = "Prefix"
  }
}

variable "lables_app_name" {
  default = "devops_exercise_"
}
