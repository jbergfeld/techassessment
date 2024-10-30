# bucket vars
variable "bucket_name" {
  description = "The s3 bucket name."
  type        = string
}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default = {
    Terraform   = "true"
  }
}
