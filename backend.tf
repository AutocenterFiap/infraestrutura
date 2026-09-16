terraform {
  cloud {
    organization = "autocenter-fiap"

    workspaces {
      name = "infraestrutura"
    }
  }
}