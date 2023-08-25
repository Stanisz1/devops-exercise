resource "kubernetes.deployment_v1" "redisdep" {

  metadata {
    name = var.deployment_redis.name
    labels = {
      test = var.lables_app_name
    }
  }

  spec {
    replicas = var.deployment_redis.replica_number

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }
      spec {
        container {
          image             = var.deployment_redis.container_image
          name              = var.deployment_redis.container_name
          image_pull_policy = "Always"
        }
      }
    }
  }
}


resource "kubernetes.deployment_v1" "backdep" {

  metadata {
    name = var.deployment_back.name
    labels = {
      test = var.lables_app_name
    }
  }

  spec {
    replicas = var.deployment_back.replica_number

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }
      spec {
        container {
          image             = var.deployment_back.container_image
          name              = var.deployment_back.container_name
          image_pull_policy = "Always"
        }
      }
    }
  }
}

resource "kubernetes.deployment_v1" "frontdep" {

  metadata {
    name = var.deployment_front.name
    labels = {
      test = var.lables_app_name
    }
  }

  spec {
    replicas = var.deployment_front.replica_number

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }
      spec {
        container {
          image             = var.deployment_front.container_image
          name              = var.deployment_front.container_name
          image_pull_policy = "Always"
        }
      }
    }
  }
}

resource "kubernetes.deployment_v1" "nginxdep" {

  metadata {
    name = var.deployment_nginx.name
    labels = {
      test = var.lables_app_name
    }
  }

  spec {
    replicas = var.deployment_nginx.replica_number

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }
      spec {
        container {
          image             = var.deployment_nginx.container_image
          name              = var.deployment_nginx.container_name
          image_pull_policy = "Always"
        }
      }
    }
  }
}
