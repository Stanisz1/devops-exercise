[
  {
    "name": "front",
    "image": "${front_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "environment": [
      {
        "name": "BACKEND_API_URL",
        "value": "http://backend-app:4000"
      },
      {
        "name": "CLIENT_API_URL",
        "value": "http://frontend-app:3000"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/front",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "containerPort": ${front_port},
        "hostPort": ${front_port}
      }
    ]
  }
]
