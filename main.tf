terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
  load_config_file       = false
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

