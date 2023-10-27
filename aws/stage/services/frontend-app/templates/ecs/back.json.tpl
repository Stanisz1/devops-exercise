[
  {
    "name": "back",
    "image": "${back_image}",
    "cpu": ${fargate_cpu_b},
    "memory": ${fargate_memory_b},
    "networkMode": "awsvpc",
    "environment": [
      {
        "name": "REDIS_SERVER",
        "value": "redis.gwxv79.clustercfg.memorydb.eu-north-1.amazonaws.com:6379"
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
