# Pave AWS for Wiz technical assessment
provider "aws" {
  region = "us-east-2"
}

# create a new vpc
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name            = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = var.my_tags
}


# create a public s3 bucket for database backups
module "postgres_backup_bucket" {
  source = "./modules/postgres_backup_bucket"

  bucket_name = "mywizbackups"

  tags = var.my_tags
}

# postgres db server
module "postgresdb_server" {
  source = "./modules/postgresdb_server"

  vpc_id     = module.vpc.vpc_id
  vpc_subnet = module.vpc.public_subnets[0]
  key_name   = var.ec2_instance_key_pair_name
  instance_profile = var.ec2_instance_profile_name
  eks_cluster_sg   = module.eks.cluster_primary_security_group_id
}

# provision an EKS cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = "terraform-cluster"
  cluster_version = "1.30"
  cluster_endpoint_public_access  = true
  cluster_encryption_config = {}
  cluster_enabled_log_types = []
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  iam_role_arn             = var.eks_cluster_iam_arn
  create_cloudwatch_log_group = false

  eks_managed_node_groups = {
    terraform_node_group = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.small"]
      iam_role_arn   = var.eks_cluster_node_iam_arn
      create_iam_role        = false
      create_iam_role_policy = false
      create_launch_template = false
      use_custom_launch_template = false
      create_schedule        = false
      enable_monitoring      = false

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    # One access entry with a policy associated
    terraform_access_entry = {
      kubernetes_groups = []
      principal_arn     = var.eks_cluster_iamuser_arn

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }

  tags = var.my_tags
}

# deploy the container application to the new cluster
module "app_deployment" {
  source = "./modules/app_deployment"

  eks_cluster_name     = module.eks.cluster_name
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_cluster_ca_cert  = module.eks.cluster_certificate_authority_data
  dbconnectionstring = "postgres://${var.dbuser}:${var.dbpassword}@${module.postgresdb_server.ec2_private_ip}:${var.dbport}/${var.dbname}"

}

