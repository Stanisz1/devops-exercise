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
  config_context   = "minikube"
  config_path = "~/.kube/config"
}


# provider "nginx" {
#   directory_availeble = "/etc/nginx/conf.d"
#   enable_symlinks = false
  
# }
# resource "nginx_service_block" "nginx_server" {
#   file = "nginx.conf"
#   content = <<EOF
# user nginx;
# worker_processes auto;

# error_log /dev/stdout info;
# pid /var/run/nginx.pid;

# events {
#   worker_connections 1024;
# }

# http {
#   access_log /dev/stdout;

#  upstream backend {
#     server backend:4000;
    
#   }

#   upstream frontend {
#     server frontend:3000;
#   }

#   server {
#     listen 80;
#     server_tokens off;
#     sendfile on;
#     tcp_nopush on;
#     tcp_nodelay on;
#     keepalive_timeout 65;
#     types_hash_max_size 2048;
#     access_log off;

#     include /etc/nginx/conf.d/*.conf;

#     location / {
#       proxy_pass http://frontend;
#       proxy_http_version 1.1;
#       proxy_set_header Connection "";
#       proxy_set_header X-Forwarded-Host $host;
#     }

#     location /api/ {
#       proxy_pass http://backend;
#       proxy_http_version 1.1;
#       proxy_set_header Connection "";
#       proxy_set_header X-Forwarded-Host $host;
#     }
#   }

#   server {
#     listen 8090;
#     location /nginx_status {
#       stub_status on;
#       access_log off;
#     }
#   }
# }
#   EOF
  
# }
