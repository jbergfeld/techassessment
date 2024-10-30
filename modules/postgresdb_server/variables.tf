variable "vpc_id" {
  description = "id of the VPC"
  type        = string
}

variable "vpc_subnet" {
  description = "network in the VPC"
  type        = string
}

variable "key_name" {
  description = "Name of ssh kay pair."
  type        = string
}

variable "instance_profile" {
  description = "Name of instance profile role."
  type        = string
}

variable "eks_cluster_sg" {
  description = "Security group of the EKS cluster"
  type        = string
}

variable "my_tags" {
  description = "Tags to apply to resources created for the instance"
  type        = map(string)
  default = {
    Name   = "postgres db server",
    Terraform   = "true"
  }
}
