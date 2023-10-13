
variable "cidr" {
  type        = string
  description = " CIDR values"
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.10.0/24", "10.0.12.0/24",]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.11.0/24", ]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-north-1a", ]
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