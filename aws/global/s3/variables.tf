variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default = "devops-exersice-staniz-s3"
}

# variable "s3_bucket" {
#   description = "Name S3 "
#   type        = string
#   default     = "devops-exersice-staniz-s3"
# }

# variable "s3_key" {
#   description = "Key for s3 bucket"
#   type        = string
#   default     = "devops-exersice-staniz-s3/global/terraform.tfstate"
# }

# variable "s3_region" {
#   description = "Region S3"
#   type        = string
#   default     = "eu-north-1"
# }
