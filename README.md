# Infraestrutura AutoCenter

Infraestrutura AWS provisionada com Terraform neste diretório. O projeto cria a
rede, o cluster Amazon EKS, o repositório de imagens e recursos Kubernetes
iniciais.

## Arquitetura

O desenho em [arquitetura.drawio](./arquitetura.drawio) representa os recursos
definidos neste projeto:

- VPC `10.0.0.0/16` na região `us-east-1`;
- Internet Gateway e tabela de rotas públicas;
- três sub-redes públicas nas zonas `us-east-1a`, `us-east-1b` e `us-east-1c`;
- cluster Amazon EKS 1.35 e node group;
- repositório Amazon ECR `autocenter-fiap`;
- entrada de acesso e política administrativa do cluster.

## Componentes

| Componente | Configuração |
| --- | --- |
| VPC | CIDR `10.0.0.0/16`, DNS habilitado. |
| Sub-redes | Três sub-redes públicas: `10.0.0.0/20`, `10.0.16.0/20` e `10.0.32.0/20`. |
| EKS | Versão 1.35, distribuído nas três sub-redes públicas. |
| Node group | Instâncias `t3.small`, de 1 a 3 nós, 2 nós desejados e disco de 20 GB. |
| ECR | Repositório com varredura de imagens no push e tags mutáveis. |
| Kubernetes | Namespace, deployment e service Nginx aplicados pelo provider `kubectl`. |

## Pré-requisitos

- Terraform 1.x;
- conta AWS com permissões para criar os recursos descritos;
- credenciais AWS configuradas localmente;
- acesso à organização `autocenter-fiap` no Terraform Cloud.

## Providers

| Provider | Versão configurada | Uso |
| --- | --- | --- |
| `hashicorp/aws` | `~> 6.0` | Provisionamento dos recursos AWS. |
| `gavinbunney/kubectl` | `>= 1.19.0` | Aplicação dos manifestos Kubernetes. |
| `hashicorp/kubernetes` | `3.2.0` | Integração com a API do cluster. |

Os providers Kubernetes e Kubectl obtêm endpoint, certificado da autoridade
certificadora e token de autenticação diretamente do EKS.

## Uso

O estado remoto é mantido no Terraform Cloud, na organização
`autocenter-fiap` e workspace `infraestrutura`.

Autentique-se e inicialize o diretório:

```bash
terraform login
terraform init
```

Revise e aplique a infraestrutura:

```bash
terraform plan
terraform apply
```

Para remover os recursos criados:

```bash
terraform destroy
```

## Variáveis

| Variável | Valor padrão | Descrição |
| --- | --- | --- |
| `projectName` | `autocenter-fiap-infraestrutura` | Nome usado nos recursos. |
| `cidr_vpc` | `10.0.0.0/16` | Bloco CIDR da VPC. |
| `instance_type` | `["t3.small"]` | Tipo das instâncias do node group. |
| `principalArn` | role `voclabs` | Principal com acesso administrativo ao EKS. |
| `labRole` | role `LabRole` | Role usada pelo cluster e node group. |

## Saídas

| Output | Descrição |
| --- | --- |
| `vpc_id` | Identificador da VPC criada. |
| `vpc_cidr` | Bloco CIDR da VPC. |
| `subnet_id` | Identificadores das três sub-redes públicas. |
| `subnet_cidr` | Blocos CIDR das três sub-redes públicas. |
| `ecr_repository_url` | URL do repositório ECR. |

## Rede e segurança

O Internet Gateway e a tabela de rotas públicas permitem conectividade externa
para as sub-redes. O security group associado ao EKS permite HTTP na porta 80
a partir da Internet e libera tráfego de saída. O acesso administrativo ao
cluster é concedido somente ao `principalArn` configurado, pela política
`AmazonEKSClusterAdminPolicy`.
