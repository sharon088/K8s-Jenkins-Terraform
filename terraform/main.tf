terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.75.0"
    }
  }
  required_version = ">= 1.9.5"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  azs                 = var.azs
}

resource "aws_security_group" "k8s_control_plane_sg" {
  name        = "k8s_control_plane_sg"
  vpc_id      = module.vpc.vpc_id
  description = "k8s control plane sg"
  dynamic "ingress" {
    for_each = var.control_plane_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.protocol_sg
      cidr_blocks = [var.vpc_cidr]
    }
  }
  #sharon edit here
  dynamic "ingress" {
    for_each = var.open_to_all_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.protocol_sg
      cidr_blocks = [var.my_ip]
    }
  }
}

resource "aws_security_group" "k8s_worker_sg" {
  name        = "k8s_worker_sg"
  vpc_id      = module.vpc.vpc_id
  description = "k8s workers sg"
  dynamic "ingress" {
    for_each = var.worker_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.protocol_sg
      cidr_blocks = [var.vpc_cidr]
    }
  }
  dynamic "ingress" {
    for_each = [30000]
    content {
      from_port   = 30000
      to_port     = 32767
      protocol    = var.protocol_sg
      cidr_blocks = [var.my_ip]
    }
  }
}

resource "aws_security_group" "jenkins_gitlab_sg" {
  name        = "jenkins_gitlab_sg"
  vpc_id      = module.vpc.vpc_id
  description = "jenkins gitlab sg"
  dynamic "ingress" {
    for_each = var.open_to_all_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.protocol_sg
      cidr_blocks = [var.my_ip]
    }
  }
}

resource "aws_instance" "k8s_master" {
  ami           = var.ami_id
  instance_type = var.small_instance_type
  tags = {
    Name = "k8s_master"
  }
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.k8s_control_plane_sg.id]
  subnet_id = module.vpc.public_subnets[0]
}

resource "aws_instance" "k8s_worker" {
  ami           = var.ami_id
  instance_type = var.k8s_worker_instance_type
  count         = 2
  tags = {
    Name = "k8s_worker"
  }
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.k8s_worker_sg.id]
  subnet_id = module.vpc.public_subnets[0]
}

resource "aws_instance" "jenkins_controller" {
  ami           = var.ami_id
  instance_type = var.small_instance_type
  tags = {
    Name = "jenkins_controller"
  }
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.jenkins_gitlab_sg.id]
  subnet_id = module.vpc.public_subnets[0]
}

resource "aws_instance" "jenkins_agent" {
  ami           = var.ami_id
  instance_type = var.small_instance_type
  tags = {
    Name = "jenkins_agent"
  }
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.jenkins_gitlab_sg.id]
  subnet_id = module.vpc.public_subnets[0]
}

resource "aws_instance" "gitlab" {
  ami           = var.ami_id
  instance_type = var.gitlab_instance_type
  tags = {
    Name = "gitlab"
  }
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.jenkins_gitlab_sg.id]
  subnet_id = module.vpc.public_subnets[0]
}