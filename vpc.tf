resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"  # CIDR block for the VPC
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id  # VPC to which the internet gateway will be attached
}

resource "aws_subnet" "pub_sub1" {
  cidr_block = "192.168.1.0/24"         # CIDR block for the first public subnet
  availability_zone = "us-east-1a"      # Availability zone for the subnet
  map_public_ip_on_launch = true        # Automatically assign a public IP to instances launched in this subnet
  vpc_id = aws_vpc.vpc.id               # VPC in which the subnet will be created
  tags = {
    "kubernetes.io/cluster/my-eks-01" = "shared"  # Tag for Kubernetes cluster discovery, updated EKS cluster name
  }
}

resource "aws_subnet" "pub_sub2" {
  cidr_block = "192.168.2.0/24"         # CIDR block for the second public subnet
  availability_zone = "us-east-1b"      # Availability zone for the subnet
  map_public_ip_on_launch = true        # Automatically assign a public IP to instances launched in this subnet
  vpc_id = aws_vpc.vpc.id               # VPC in which the subnet will be created
  tags = {
    "kubernetes.io/cluster/my-eks-01" = "shared"  # Tag for Kubernetes cluster discovery, updated EKS cluster name
  }
}

resource "aws_subnet" "priv_sub1" {
  cidr_block = "192.168.3.0/24"         # CIDR block for the first private subnet
  availability_zone = "us-east-1c"      # Availability zone for the subnet
  vpc_id = aws_vpc.vpc.id               # VPC in which the subnet will be created
  tags = {
    "kubernetes.io/cluster/my-eks-01" = "shared"  # Tag for Kubernetes cluster discovery, updated EKS cluster name
  }
}

resource "aws_subnet" "priv_sub2" {
  cidr_block = "192.168.4.0/24"         # CIDR block for the second private subnet
  availability_zone = "us-east-1d"      # Availability zone for the subnet
  vpc_id = aws_vpc.vpc.id               # VPC in which the subnet will be created
  tags = {
    "kubernetes.io/cluster/my-eks-01" = "shared"  # Tag for Kubernetes cluster discovery, updated EKS cluster name
  }
}

resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.vpc.id  # VPC for the private route table
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id  # VPC for the public route table
}

resource "aws_route_table_association" "pub-sub1-rt-association" {
  route_table_id = aws_route_table.pub_rt.id  # ID of the public route table
  subnet_id      = aws_subnet.pub_sub1.id     # ID of the public subnet 1
}

resource "aws_route_table_association" "pub-sub2-rt-association" {
  route_table_id = aws_route_table.pub_rt.id  # ID of the public route table
  subnet_id      = aws_subnet.pub_sub2.id     # ID of the public subnet 2
}

resource "aws_route_table_association" "priv-sub1-rt-association" {
  route_table_id = aws_route_table.priv_rt.id  # ID of the private route table
  subnet_id      = aws_subnet.priv_sub1.id     # ID of the private subnet 1
}

resource "aws_route_table_association" "priv-sub2-rt-association" {
  route_table_id = aws_route_table.priv_rt.id  # ID of the private route table
  subnet_id      = aws_subnet.priv_sub2.id     # ID of the private subnet 2
}

resource "aws_route" "pub-rt" {
  route_table_id = aws_route_table.pub_rt.id    # ID of the public route table
  destination_cidr_block = "0.0.0.0/0"          # Route for all traffic
  gateway_id = aws_internet_gateway.igw.id      # Internet gateway for public subnets
}

