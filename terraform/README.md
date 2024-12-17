# Terraform AWS Infrastructure

This repository contains a Terraform configuration that automates the provisioning of an AWS infrastructure, including a Virtual Private Cloud (VPC), subnets, security groups, EC2 instances, and associated resources. This setup is designed for deploying a Kubernetes cluster, Jenkins, and GitLab within an AWS environment.

## Table of Contents

- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Usage Instructions](#usage-instructions)
  - [Clone the Repository](#clone-the-repository)
  - [Configure Terraform](#configure-terraform)
  - [Initialize Terraform](#initialize-terraform)
  - [Validate the Configuration](#validate-the-configuration)
  - [Plan the Deployment](#plan-the-deployment)
  - [Apply the Configuration](#apply-the-configuration)
  - [Destroy the Infrastructure](#destroy-the-infrastructure)
- [Variables](#variables)
  - [Root Module Variables](#root-module-variables)
  - [VPC Module Variables](#vpc-module-variables)
- [Outputs](#outputs)

## Project Overview

This Terraform configuration manages the following AWS resources:
- A VPC with configurable CIDR block and availability zones.
- Public and private subnets.
- Elastic IP (EIP) for NAT gateway.
- NAT Gateway for routing traffic from private subnets to the internet.
- Route tables for public and private subnets.
- EC2 instances for Kubernetes control plane and worker nodes, Jenkins, and GitLab.
- Security groups for controlling access to the EC2 instances.

## Prerequisites

Before you can use this Terraform configuration, make sure you have the following installed:
- [Terraform](https://www.terraform.io/downloads.html) (version >= 1.9.5)
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- [AWS Account](https://aws.amazon.com)

### AWS Credentials Setup
Terraform uses your AWS credentials for provisioning resources. You can configure your AWS credentials in the following ways:
1. By setting environment variables:
    ```bash
    export AWS_ACCESS_KEY_ID="your_access_key"
    export AWS_SECRET_ACCESS_KEY="your_secret_key"
    ```
2. By using the AWS CLI:
    ```bash
    aws configure
    ```

## Directory Structure

This Terraform configuration is organized as follows:

```
terraform-aws-infrastructure/
├── main.tf               # Root module, includes VPC and EC2 resource definitions
├── variables.tf          # Variable definitions for root module
├── outputs.tf            # Output definitions for root module
├── terraform.tfvars      # Default variable values for the root module
├── modules/              # Custom Terraform modules
│   └── vpc/              # VPC module containing VPC, subnets, and other network-related resources
│       ├── main.tf       # Resource definitions for VPC module
│       ├── variables.tf  # Variable definitions for VPC module
│       └── outputs.tf    # Output definitions for VPC module
└── README.md             # This file
```

### `main.tf` (Root Module)
- Defines the root module, which includes the VPC module and EC2 instances like Kubernetes control plane, workers, Jenkins, and GitLab.

### `variables.tf` (Root Module)
- Defines variables for the root module, such as instance types, VPC CIDR block, AWS region, etc.

### `outputs.tf` (Root Module)
- Outputs for the root module, like the public IPs of the EC2 instances, VPC ID, subnet IDs, etc.

### `modules/vpc/main.tf`
- Defines the resources for creating a VPC, subnets (public and private), NAT gateway, route tables, etc.

### `modules/vpc/variables.tf`
- Variable definitions for the VPC module, like CIDR blocks for subnets, availability zones, etc.

### `modules/vpc/outputs.tf`
- Output definitions for the VPC module, including VPC ID, subnet IDs, and NAT gateway IDs.

## Usage Instructions

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/your-repository/terraform-aws-infrastructure.git
    cd terraform-aws-infrastructure
    ```

2. **Configure Terraform**:
    - Set up your `terraform.tfvars` file with values for required variables, or use command-line arguments.
    - Example `terraform.tfvars`:
        ```hcl
        aws_region = "us-west-2"
        vpc_cidr = "10.0.0.0/16"
        azs = ["us-west-2a", "us-west-2b"]
        ami_id = "ami-0abcd1234567890ab"
        ```

3. **Initialize Terraform**:
    - Initialize the Terraform working directory to download the required provider plugins:
    ```bash
    terraform init
    ```

4. **Validate the Configuration**:
    - Ensure the configuration is correct before applying:
    ```bash
    terraform validate
    ```

5. **Plan the Deployment**:
    - Generate an execution plan to see what Terraform will do:
    ```bash
    terraform plan
    ```

6. **Apply the Configuration**:
    - Apply the changes and provision the resources in AWS:
    ```bash
    terraform apply
    ```

7. **Destroy the Infrastructure** (Optional):
    - To clean up and remove the infrastructure:
    ```bash
    terraform destroy
    ```

## Variables

Here is a list of the main variables used in the Terraform configuration:

### Root Module Variables (`variables.tf`)

| Variable              | Description                                               | Type     | Default Value |
|-----------------------|-----------------------------------------------------------|----------|---------------|
| `aws_region`          | The AWS region where resources will be deployed.          | `string` | `"us-west-2"`  |
| `vpc_cidr`            | CIDR block for the VPC.                                   | `string` | `"10.0.0.0/16"`|
| `azs`                 | List of availability zones for the VPC subnets.           | `list(string)` | `["us-west-2a", "us-west-2b"]` |
| `ami_id`              | The AMI ID to use for EC2 instances.                      | `string` | `"ami-0abcd1234567890ab"` |
| `control_plane_ports` | List of ports for control plane security group ingress.   | `list(any)` | `[22, 80, 6443, 2379, 2380, 10250, 10259, 10257]` |
| `worker_ports`        | List of ports for worker instance security group ingress. | `list(any)` | `[22, 80, 5000, 10250, 10256]` |
| `jenkins_gitlab_ports`| List of ports for Jenkins and GitLab instances.           | `list(any)` | `[22, 80, 443, 2424, 8080]` |

### VPC Module Variables (`modules/vpc/variables.tf`)

| Variable            | Description                                           | Type     | Default Value |
|---------------------|-------------------------------------------------------|----------|---------------|
| `vpc_cidr`          | CIDR block for the VPC.                               | `string` | `"10.0.0.0/16"` |
| `azs`               | Availability zones for the VPC subnets.               | `list(string)` | `["us-west-2a", "us-west-2b"]` |
| `public_subnet_cidr`| CIDR block for the public subnet.                     | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24"]` |
| `private_subnet_cidr`| CIDR block for the private subnet.                    | `list(string)` | `["10.0.3.0/24", "10.0.4.0/24"]` |

## Outputs

Here are the main outputs of the Terraform configuration:

### Root Module Outputs (`outputs.tf`)

| Output                    | Description                                           |
|---------------------------|-------------------------------------------------------|
| `vpc_id`                   | The ID of the created VPC.                            |
| `public_subnets`           | The IDs of the created public subnets.                |
| `private_subnets`          | The IDs of the created private subnets.               |
| `k8s_master_instance_ip`   | The public IP of the Kubernetes master instance.      |
| `k8s_worker_instance_ips`  | The public IPs of the Kubernetes worker instances.    |
| `jenkins_controller_instance_ip` | The public IP of the Jenkins controller instance.  |
| `jenkins_agent_instance_ips` | The public IPs of the Jenkins agent instances.        |
| `gitlab_instance_ip`       | The public IP of the GitLab instance.                 |

