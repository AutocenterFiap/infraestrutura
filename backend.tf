terraform {
  backend "s3" {
    bucket = "autocenter-fiap-infraestrutura"
    key    = "autocenter-fiap/terraform.tfstate"
    region = "us-east-1"
  }
}
