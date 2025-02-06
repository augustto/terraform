terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

# Lista de subnets disponíveis
variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-0aa7744eb5dc42134", "subnet-021840285d79b1695"] 
}

# Escolhe aleatoriamente uma subnet
resource "random_shuffle" "selected_subnet" {
  input        = var.subnet_ids
  result_count = 1
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0c94855ba95c71c99"  
  instance_type          = "t2.micro"
  key_name = "main-ssh-key"
  subnet_id              = random_shuffle.selected_subnet.result[0]  # Usa apenas 1 subnet
  depends_on             = [random_shuffle.selected_subnet]  # Garante que a subnet seja escolhida antes

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
