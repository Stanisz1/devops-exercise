variable "tf_token" {}

variable "files" {
  default = [
    "redisdep.tf",
    "frontdep.tf",
    "backdep.tf",
    "nginxdep.tf",
    "service.tf",
    "ingress.tf",
    "provider.tf",
    "locals.tf",
    "provider.tf",
    "github/provider.tf",
    "github/repo.tf",
    "github/variables.tf"
  ]
}
