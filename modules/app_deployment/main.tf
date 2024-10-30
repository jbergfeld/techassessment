# from EKS
provider "aws" {
  region = "us-east-2"
}

#data "aws_eks_cluster" "cluster" {
#  name = var.eks_cluster_name
#}

provider "kubernetes" {
  #host                   = data.aws_eks_cluster.cluster.endpoint
  host                   = var.eks_cluster_endpoint
  #cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  cluster_ca_certificate = base64decode(var.eks_cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      #data.aws_eks_cluster.cluster.name
      var.eks_cluster_name
    ]
  }
}

resource "kubernetes_service_account" "sa" {
  metadata {
    name = "eksadmin"
  }
}

resource "kubernetes_cluster_role_binding_v1" "cluster_admin_pod" {
  metadata {
    name = "cluster-admin-sa-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "eksadmin"
    namespace = "default"
  }
}

resource "kubernetes_deployment" "hello-kubernetes-deploy" {
  metadata {
    name = "hello-kubernetes-deploy"
  }

  spec {
    selector {
      match_labels = {
        app = "hello-kubernetes"
      }
    }
    template {
      metadata {
        labels = {
          app = "hello-kubernetes"
        }
      }
      spec {
        service_account_name = "eksadmin"
        container {
          name  = "hello-kubernetes"
          image = "jonsimages/wiz:stable"

          port {
            container_port = "8080"
          }

          env {
            name = "DBCONNSTRING"
            value = var.dbconnectionstring
          }

          env {
            name = "PORT"
            value = "8080"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello-kubernetes-svc" {
  metadata {
    name = "hello-kubernetes-svc"
  }
  spec {
    selector = {
      app = kubernetes_deployment.hello-kubernetes-deploy.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

