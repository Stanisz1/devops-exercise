terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = "eu-north-1" 

}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

# ---------------------------------------------------------------------------------------------------
#                                                   VPC
# ---------------------------------------------------------------------------------------------------

resource "aws_vpc" "main" {
 cidr_block =  var.cidr
 
 tags = {
   Name = var.name_vpc
 }
}

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = var.name_ig
 }
}

resource "aws_subnet" "private_subnets_a" {
 count             = length(var.private_subnet_cidrs_a)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.private_subnet_cidrs_a, count.index)
 availability_zone = element(var.azs_a, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

resource "aws_subnet" "public_subnets_a" {
 count             = length(var.public_subnet_cidrs_a)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.public_subnet_cidrs_a, count.index)
 availability_zone = element(var.azs_a, count.index)
 map_public_ip_on_launch = true
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}

resource "aws_subnet" "private_subnets_b" {
 count             = length(var.private_subnet_cidrs_b)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.private_subnet_cidrs_b, count.index)
 availability_zone = element(var.azs_b, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

resource "aws_subnet" "public_subnets_b" {
 count             = length(var.public_subnet_cidrs_b)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.public_subnet_cidrs_b, count.index)
 availability_zone = element(var.azs_b, count.index)
 map_public_ip_on_launch = true
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}

resource "aws_eip" "nat_a" {
  vpc = true

  tags = {
    Name = "nat-a"
  }
}

resource "aws_eip" "nat_b" {
  vpc = true

  tags = {
    Name = "nat-b"
  }
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  count         = length(var.public_subnet_cidrs_a)
  subnet_id     = element(aws_subnet.public_subnets_a[*].id, count.index)

  tags = {
    Name = "${var.name_nat}-a"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.id
  count         = length(var.public_subnet_cidrs_b)
  subnet_id     = element(aws_subnet.public_subnets_b[*].id, count.index)

  tags = {
    Name = "${var.name_nat}-b"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = aws_nat_gateway.nat_a
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = route.value.id
    }
  }

  tags = {
    Name = "${var.name_rt_private}-a"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = aws_nat_gateway.nat_b
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = route.value.id
    }
  }

  tags = {
    Name = "${var.name_rt_private}-b"
  }
}

resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name_rt_public}-a"
  }
}

resource "aws_route_table" "public_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name_rt_public}-b"
  }
}


resource "aws_route_table_association" "private_a" {
 count = length(var.private_subnet_cidrs_a)
 subnet_id      = element(aws_subnet.private_subnets_a[*].id, count.index)
 route_table_id = element(aws_route_table.private_a.*.id, count.index)
}

resource "aws_route_table_association" "private_b" {
 count = length(var.private_subnet_cidrs_b)
 subnet_id      = element(aws_subnet.private_subnets_b[*].id, count.index)
 route_table_id = element(aws_route_table.private_b.*.id, count.index)
}

resource "aws_route_table_association" "public_a" {
 count = length(var.public_subnet_cidrs_a)
 subnet_id      = element(aws_subnet.public_subnets_a[*].id, count.index)
 route_table_id = element(aws_route_table.public_a.*.id, count.index)
}

resource "aws_route_table_association" "public_b" {
 count = length(var.public_subnet_cidrs_b)
 subnet_id      = element(aws_subnet.public_subnets_b[*].id, count.index)
 route_table_id = element(aws_route_table.public_b.*.id, count.index)
}

# ---------------------------------------------------------------------------------------------------
#                                            SECIRITY GROUP
# ---------------------------------------------------------------------------------------------------

resource "aws_security_group" "lb" {
  name        = "front-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}
  locals {
    http_port    = 80
    any_port     = 0
    any_protocol = "-1"
    tcp_protocol = "tcp"
    all_ips      = ["0.0.0.0/0"]
  }


# Traffic to the ECS cluster should only come from the ALB

resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.main.id
  ingress {
    protocol        = "tcp"
    from_port       = var.front_port
    to_port         = var.front_port
    security_groups = [aws_security_group.lb.id]
  }
  ingress {
    protocol        = "tcp"
    from_port       = var.back_port
    to_port         = var.back_port
    security_groups = [aws_security_group.lb.id]
  }
  ingress {
    description      = "redis"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}




# ---------------------------------------------------------------------------------------------------
#                                            application load balancer
# ---------------------------------------------------------------------------------------------------

resource "aws_alb" "main" {
  name               = "main-load-balancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = concat(aws_subnet.public_subnets_a[*].id, aws_subnet.public_subnets_b[*].id,)
}

resource "aws_alb_target_group" "front" {
  name        = "front-target-group"
  port        = var.front_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_target_group" "back" {
  name        = "back-target-group"
  port        = var.back_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "main_end" {
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.front.id
    type             = "forward"
  }
}

# Rull for front 
resource "aws_alb_listener_rule" "front" {
  listener_arn = aws_alb_listener.main_end.arn
  priority    = 101

  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.front.id
  }
}

# Rull for back

resource "aws_alb_listener_rule" "back" {
  listener_arn = aws_alb_listener.main_end.arn
  priority    = 100

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
   action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.back.id
  }
}

# ---------------------------------------------------------------------------------------------------
#                                           ECS cluster-front
# ---------------------------------------------------------------------------------------------------

resource "aws_ecs_cluster" "front" {
  name = "devops-exersice"
}

data "template_file" "front" {
  template = file("./templates/ecs/front.json.tpl")

  vars = {
    front_image    = var.front_image
    front_port     = var.front_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory 
    aws_region     = var.aws_region
  }
}

data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs-staging-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "front" {
  family                   = "front-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.front.rendered
}

resource "aws_ecs_service" "front" {
  name            = "front-service"
  cluster         = aws_ecs_cluster.front.id
  task_definition = aws_ecs_task_definition.front.arn
  desired_count   = var.front_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = concat(aws_subnet.public_subnets_b[*].id)
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.front.id
    container_name   = "front"
    container_port   = var.front_port
  }

  depends_on = [aws_alb_listener.main_end, aws_iam_role_policy_attachment.ecs_task_execution_role, aws_ecs_service.back]
}

# ---------------------------------------------------------------------------------------------------
#                                           ECS cluster-back
# ---------------------------------------------------------------------------------------------------

resource "aws_ecs_cluster" "back" {
  name = "devops-exersice"
}

data "template_file" "back" {
  template = file("./templates/ecs/back.json.tpl")

  vars = {
    back_image       = var.back_image
    back_port        = var.back_port
    fargate_cpu_b    = var.fargate_cpu_b
    fargate_memory_b = var.fargate_memory_b
    aws_region       = var.aws_region
    aws_redis        = aws_memorydb_cluster.redis_cluster.cluster_endpoint[0].address
    aws_redis_port   = aws_memorydb_cluster.redis_cluster.cluster_endpoint[0].port
  }
}
data "aws_iam_policy_document" "ecs_task_execution_role_back" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "redis_connect_policy" {
  name        = "RedisConnectPolicy"
  description = "Allows redis:Connect action"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "redis:Connect",
        Effect   = "Allow",
        Resource = "arn:aws:memorydb:eu-north-1:${local.account_id}:cluster/redis"
      }
    ]
  })
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

resource "aws_iam_policy" "ecs_task_execution_role_policy_memorydb" {
  name        = "ECSTaskExecutionRolePolicy"
  description = "Policy for ECS Task Execution Role"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "memorydb:*",
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "iam:CreateServiceLinkedRole",
        Resource = "arn:aws:iam::*:role/aws-service-role/memorydb.amazonaws.com/AWSServiceRoleForMemoryDB",
        Condition = {
          StringLike = {
            "iam:AWSServiceName" = "memorydb.amazonaws.com"
          }
        }
      },
    ]
  })
}


resource "aws_iam_policy_attachment" "ecs_task_execution_role_memorydb" {
  name       = "ecs_task_execution_role_memorydb"
  policy_arn = aws_iam_policy.ecs_task_execution_role_policy_memorydb.arn
  roles      = [aws_iam_role.ecs_task_execution_role_back.name]
}
resource "aws_iam_policy_attachment" "ecs_task_execution_role_redis" {
  name       = "ecs_task_execution_role_redis"
  policy_arn = aws_iam_policy.redis_connect_policy.arn
  roles      = [aws_iam_role.ecs_task_execution_role_back.name]
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_back" {
  role       = aws_iam_role.ecs_task_execution_role_back.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_execution_role_back" {
  name               = "ecs-staging-execution-role-back"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_back.json
}

resource "aws_ecs_task_definition" "back" {
  family                   = "back-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role_back.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu_b
  memory                   = var.fargate_memory_b
  container_definitions    = data.template_file.back.rendered
  
}

resource "aws_ecs_service" "back" {
  name            = "back-service"
  cluster         = aws_ecs_cluster.back.id
  task_definition = aws_ecs_task_definition.back.arn
  desired_count   = var.back_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = concat(aws_subnet.private_subnets_b[*].id)
    assign_public_ip = true

  }

  load_balancer {
    target_group_arn = aws_alb_target_group.back.id
    container_name   = "back"
    container_port   = var.back_port
  }

  depends_on = [aws_alb_listener.main_end, aws_alb_listener_rule.back, aws_iam_role_policy_attachment.ecs_task_execution_role_back, aws_memorydb_cluster.redis_cluster]
}


# ---------------------------------------------------------------------------------------------------
#                                           Memory DB for redis 
# ---------------------------------------------------------------------------------------------------

resource "aws_memorydb_cluster" "redis_cluster" {
  acl_name                 = "open-access" 
  name                     = "redis"
  node_type                = "db.t4g.small"
  num_shards               = 1
  security_group_ids       = [aws_security_group.ecs_tasks.id]
  snapshot_retention_limit = 7
  subnet_group_name        = aws_memorydb_subnet_group.redis_subnet_group.id
  port                     = 6379
  tls_enabled              = false
}

resource "aws_memorydb_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids =  concat(aws_subnet.private_subnets_b[*].id)
}

terraform {
  backend "s3" {
    bucket         = "devops-exersice-staniz-s3"
    key            = "devops-exersice-staniz-s3/stage/services/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
  }
}