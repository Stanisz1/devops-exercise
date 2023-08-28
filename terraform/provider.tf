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
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "service.clusterip.http"
    value = "30201"
  }
  

  provisioner "local-exec" {
    command = <<-EOT
      cat <<EOL > nginx.conf
      events {
        worker_connections 1024;
      }

      http {
        access_log /dev/stdout;

        upstream backend {
          server back:4000;
        }

        upstream frontend {
          server front:3000;
        }

        server {
          listen 80;
          server_tokens off;
          sendfile on;
          tcp_nopush on;
          tcp_nodelay on;
          keepalive_timeout 65;
          types_hash_max_size 2048;
          access_log off;

          location / {
            proxy_pass http://frontend;
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            proxy_set_header X-Forwarded-Host $host;
          }

          location /api/ {
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            proxy_set_header X-Forwarded-Host $host;
          }
        }

        server {
          listen 8090;
          location /nginx_status {
            stub_status on;
            access_log off;
          }
        }
      }
      EOL

      sudo mv nginx.conf /etc/nginx/nginx.conf
      sudo systemctl reload nginx
    EOT
  }
}


