[
  {
    "name": "back",
    "image": "${back_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "environment": [
      {
        "name": "REDIS_SERVER",
        "value": "${redis_endpoint}"
      },
      {
        "name": "REDIS_PORT",
        "value": "6379"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/back",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "containerPort": ${back_port},
        "hostPort": ${back_port}
      }
    ]
  }
]
