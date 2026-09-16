resource "aws_ecr_repository" "autocenter" {
  name                 = "autocenter-fiap"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}
