# Terraform EKS Project

This repository contains Terraform configurations to provision and manage an Amazon EKS (Elastic Kubernetes Service) cluster. The project provides a complete setup for a scalable, secure Kubernetes environment on AWS, including networking, IAM roles, node groups, and security configurations.

## Project Structure

The project is organized into the following files:

- **'provider.tf'**:Configures the AWS provider and specifies the region where resources will be created.
- **'vpc.tf'**:Defines the VPC, subnets (public and private), route tables, and internet gateway.
- **`eks.tf`**: Creates the EKS cluster, specifying the IAM roles and VPC configurations.
- **`nodegroup.tf`**: Configures EKS node groups for different environments (frontend and backend), including scaling and access settings.
- **`role.tf`**: Defines IAM roles and policies for EKS master and worker nodes, including policies for autoscaling and container registry access.
- **`sg.tf`**: Sets up security groups for EKS nodes, allowing inbound SSH access.
- **`output.tf`**: Outputs the EKS cluster endpoint for easy access.

## Prerequisites

Before you start, ensure you have the following:

- [Terraform](https://www.terraform.io/downloads) (v0.12 or later) installed on your machine.
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials that have appropriate permissions to create and manage AWS resources.

## Getting Started

Follow these steps to deploy the EKS cluster:

### 1. Clone the Repository

Start by cloning the repository to your local machine:

```bash
git clone https://github.com/lakshmi-Thungala/EKS-Deployment.git

