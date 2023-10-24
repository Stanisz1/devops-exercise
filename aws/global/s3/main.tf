terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      Version = "~>3.27"
    }
  }

  required_version = ">=0.14.9"
 
    backend "s3" {
    bucket         = "devops-exersice-staniz-s3"
    key            = "devops-exersice-staniz-s3/global/s3/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
  }
}
provider "aws" {
  version = "~>3.0"
  region = "eu-north-1"
}

resource "aws_s3_bucket" "terraform_state" {

  bucket = var.bucket_name

}

# Enable versioning so you can see the full revision history of your
# state files
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# terraform {
#   backend "s3" {
#     bucket         = "devops-exersice-staniz-s3"
#     key            = "devops-exersice-staniz-s3/global/s3/terraform.tfstate"
#     region         = "eu-north-1"

#     encrypt        = true
#   }
# }

# terraform {
#   backend "s3" {
#     bucket         = "${var.s3_bucket}"
#     key            = "${var.s3_key}"
#     region         = "${var.s3_region}"

#     encrypt        = true
#   }
# }


