variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "eu-north-1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role Name"
  default     = "myEcsAutoScaleRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "1"
}

variable "front_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "ghcr.io/stanisz1/front:latest"
}

variable "front_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "front_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "back_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "ghcr.io/stanisz1/back:latest"
}

variable "back_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 4000
}

variable "back_count" {
  description = "Number of docker containers to run"
  default     = 1
}


variable "redis_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "ghcr.io/stanisz1/redis:latest"
}

variable "redis_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 6379
}

variable "redis_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu_b" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "512"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "1024"
}

variable "fargate_memory_b" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "cidr" {
  type        = string
  description = " CIDR values"
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs_a" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.10.0/24", "10.0.11.0/24", ]
}

variable "public_subnet_cidrs_a" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.13.0/24", ]
}

variable "private_subnet_cidrs_b" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.20.0/24", "10.0.21.0/24", ]
}

variable "public_subnet_cidrs_b" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.23.0/24", ]
}

variable "azs_a" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-north-1a", ]
}

variable "azs_b" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-north-1b", ]
}

variable "name_vpc" {
  type        = string
  description = "name VPC"
  default     = "devops-exersice-vpc"
}

variable "name_nat" {
  type        = string
  description = "name NAT"
  default     = "devops-exersice-nat"
}

variable "name_ig" {
  type        = string
  description = "name IG"
  default     = "devops-exersice-vpc-ig"
}

variable "name_rt_private" {
  type        = string
  description = "name Route tables"
  default     = "devops-exersice-vpc-rt-private"
}

variable "name_rt_public" {
  type        = string
  description = "name Route tables"
  default     = "devops-exersice-vpc-rt-public"
}


variable "alb_security_group_name" {
  description = "The name of the security group for the ALB"
  type        = string
  default     = "devops-exersice-sc-alb"
}