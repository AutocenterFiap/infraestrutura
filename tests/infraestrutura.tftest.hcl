mock_provider "aws" {}

override_data {
  target = data.aws_eks_cluster.cluster
  values = {
    endpoint = "https://eks.example.invalid"
    certificate_authority = [{
      data = "Y2VydGlmaWNhdGU="
    }]
    vpc_config = [{
      cluster_security_group_id = "sg-0123456789abcdef0"
    }]
  }
}

override_data {
  target = data.aws_eks_cluster_auth.auth
  values = {
    token = "test-token"
  }
}

run "planeja_rede_publica" {
  command = plan

  assert {
    condition     = aws_vpc.vpc_autocenter.cidr_block == "10.0.0.0/16"
    error_message = "A VPC deve usar o CIDR 10.0.0.0/16."
  }

  assert {
    condition     = length(aws_subnet.subnet_public) == 3
    error_message = "A infraestrutura deve criar tres sub-redes publicas."
  }

  assert {
    condition     = alltrue([for subnet in aws_subnet.subnet_public : subnet.map_public_ip_on_launch])
    error_message = "As sub-redes publicas devem atribuir IP publico."
  }
}

run "planeja_repositorio_ecr" {
  command = plan

  assert {
    condition     = aws_ecr_repository.autocenter.name == "autocenter-fiap"
    error_message = "O repositorio ECR deve se chamar autocenter-fiap."
  }

  assert {
    condition     = aws_ecr_repository.autocenter.image_scanning_configuration[0].scan_on_push
    error_message = "O ECR deve analisar imagens no push."
  }
}
