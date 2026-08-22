output "vpc_cidr" {
  value = aws_vpc.vpc_autocenter.cidr_block
}

output "vpc_id" {
  value = aws_vpc.vpc_autocenter.id
}

output "subnet_cidr" {
  value = aws_subnet.subnet_public[*].cidr_block
}

output "subnet_id" {
  value = aws_subnet.subnet_public[*].id
}

output "ecr_repository_url" {
  description = "URL do repositorio ECR usado para publicar a imagem Docker da aplicacao"
  value       = aws_ecr_repository.autocenter.repository_url
}