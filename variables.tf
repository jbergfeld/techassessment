variable "my_tags" {
  description = "Tags to apply to resources created by terraform"
  type        = map(string)
  default = {
    Terraform   = "true"
  }
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.10.101.0/24", "10.10.102.0/24"]
}

variable "ec2_instance_key_pair_name" {
  description = "SSH key pair name"
  type        = string
}

variable "ec2_instance_profile_name" {
  description = "IAM role to use as an Instance Profile"
  type        = string
}

variable "eks_cluster_iam_arn" {
  description = "IAM role for the cluster"
  type        = string
}

variable "eks_cluster_node_iam_arn" {
  description = "IAM role for the node group"
  type        = string
}

variable "eks_cluster_iamuser_arn" {
  description = "IAM user for access to the cluster"
  type        = string
}

variable "dbhost" {
  description = "Database server host/IP"
  type        = string
}

variable "dbport" {
  description = "Database port"
  type        = string
  default     = "5432"
}

variable "dbuser" {
  description = "Database user"
  type        = string
}

variable "dbpassword" {
  description = "Database password"
  type        = string
}

variable "dbname" {
  description = "Database name"
  type        = string
}

