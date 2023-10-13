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
  region = "eu-north-1"
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
 
resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 map_public_ip_on_launch = true
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  count         = length(var.public_subnet_cidrs)
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = {
    Name = var.name_nat
  }

  depends_on = [aws_internet_gateway.igw]
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = aws_nat_gateway.nat
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = route.value.id
    }
  }

  tags = {
    Name = var.name_rt_private
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.name_rt_public
  }
}

resource "aws_route_table_association" "private" {
 count = length(var.private_subnet_cidrs)
 subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
 route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route_table_association" "public" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = element(aws_route_table.public.*.id, count.index)
}


# ---------------------------------------------------------------------------------------------------
#                                            SECIRITY GROUP
# ---------------------------------------------------------------------------------------------------

resource "aws_security_group" "alb" {
  name   = "${var.alb_security_group_name}"
  vpc_id = aws_vpc.main.id
 
  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   cidr_blocks      = ["0.0.0.0/0"]
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = 443
   to_port          = 443
   cidr_blocks      = ["0.0.0.0/0"]
  }
 
  # ingress {
  #  protocol         = "tcp"
  #  from_port        = 22
  #  to_port          = 22
  #  cidr_blocks      = ["0.0.0.0/0"]
  # }

  egress {
   protocol         = "tcp"
   from_port        = 3000
   to_port          = 3000
   cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
   protocol         = "tcp"
   from_port        = 4000
   to_port          = 4000
   cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
   protocol         = "tcp"
   from_port        = 6379
   to_port          = 6379
   cidr_blocks      = ["0.0.0.0/0"]
  }

}

terraform {
  backend "s3" {
    bucket         = "devops-exersice-staniz-s3"
    key            = "devops-exersice-staniz-s3/modules/vpc/terraform.tfstate"
    region         = "eu-north-1"

    encrypt        = true
  }
}