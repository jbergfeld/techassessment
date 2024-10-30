variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "eks_cluster_ca_cert" {
  description = "EKS cluster CA certificate"
  type        = string
}

variable "dbconnectionstring" {
  description = "Database connection string"
  type        = string
}

