variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "ami_id" {
  description = "AMI ID to use for instances"
  type        = string
  default     = "ami-0084a47cc718c111a"
}

variable "ssh_key_name" {
  description = "Key name to connect to instance"
  type        = string
  default     = "k8s"
}

variable "k8s_worker_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "gitlab_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.large"
}

variable "small_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.small"
}

variable "protocol_sg" {
  description = "The protocol used for Kubernetes security group ingress rules"
  type        = string
  default     = "tcp"
}

variable "control_plane_ports" {
  description = "List of ports for control plane instance ingress rules"
  type        = list(any)
  default     = [2379, 2380 ,10250, 10259, 10257]
}

variable "my_ip" {
  description = "My Ip"
  type        = string
  default     = "213.57.121.34/32"
}

variable "worker_ports" {
  description = "List of ports for worker instance ingress rules"
  type        = list(any)
  default     = [10250, 10256]
}

variable "open_to_all_ports" {
  description = "List of ports for all instances ingress rules"
  type        = list(any)
  default     = [22, 80, 443, 2424, 5000, 8080]
}

variable "vpc_cidr" {
  description = "VPC CIDR blocks"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "azs" {
  description = "Availability zones for the VPC"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}