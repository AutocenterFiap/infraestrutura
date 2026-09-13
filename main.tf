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

   # Desabilita chamadas de metadata de S3/Object Lock bloqueadas pela SCP do AWS Academy
  s3_use_path_style           = true
  skip_requesting_account_id  = false

  # Se houver recursos S3 gerenciados que disparam checagem de Object Lock:
  # O provider AWS permite ignorar checagens de S3 ativando skip_metadata_api_check
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

