variable "projectName" {
  description = "Nome do projeto"
  default     = "autocenter-fiap-infraestrutura"
}

variable "cidr_vpc" {
  description = "Bloco de ip para a VPC"
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Tags para os recursos"
  default = {
    Name = "autocenter-fiap-infraestrutura"
  }

}

variable "principalArn" {
  description = "ARN do principal"
  default     = "arn:aws:iam::698096482625:role/voclabs"
}

variable "labRole" {
  default = "arn:aws:iam::698096482625:role/LabRole"
}

variable "instance_type" {
  description = "Tipo de instância para o grupo de nós"
  default     = ["t3.small"]
}