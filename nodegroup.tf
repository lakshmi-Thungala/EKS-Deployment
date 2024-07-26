resource "aws_eks_node_group" "frontend" {
  cluster_name    = aws_eks_cluster.eks.name    # Name of the EKS cluster to associate with this node group
  node_group_name = "prod"                      # Name for the frontend node group
  node_role_arn   = aws_iam_role.worker.arn     # ARN of the IAM role for the node group
  capacity_type   = "ON_DEMAND"                 # Specifies whether the nodes are on-demand or spot instances
  disk_size       = "20"                        # Disk size (in GB) for each node in the group
  instance_types  = ["t3.medium"]               # Instance type for the nodes

  remote_access {
    ec2_ssh_key = "lucky_eks"                   # SSH key name to access the nodes
    source_security_group_ids = [aws_security_group.node.id]  # Security group for SSH access
  } 

  taint {
    key    = "frontend"                         # Key for the taint
    value  = "yes"                              # Value for the taint
    effect = "NO_SCHEDULE"                      # Effect of the taint, prevents scheduling non-tolerating pods
  }

  subnet_ids = [aws_subnet.pub_sub1.id, aws_subnet.pub_sub2.id]  # Subnets for the node group

  scaling_config {
    desired_size = 1                            # Desired number of nodes
    max_size     = 2                            # Maximum number of nodes
    min_size     = 1                            # Minimum number of nodes
  }

  update_config {
    max_unavailable = 1                         # Maximum number of nodes that can be unavailable during updates
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,          # Ensures this policy is attached before creating the node group
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,               # Ensures this policy is attached before creating the node group
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly, # Ensures this policy is attached before creating the node group
    aws_subnet.pub_sub1,                                               # Ensures this subnet is created before creating the node group
    aws_subnet.pub_sub2,                                               # Ensures this subnet is created before creating the node group
  ]
}

resource "aws_eks_node_group" "backend" {
  cluster_name    = aws_eks_cluster.eks.name    # Name of the EKS cluster to associate with this node group
  node_group_name = "dev"                       # Name for the backend node group
  node_role_arn   = aws_iam_role.worker.arn     # ARN of the IAM role for the node group
  subnet_ids      = [aws_subnet.pub_sub1.id, aws_subnet.pub_sub2.id]  # Subnets for the node group
  capacity_type   = "ON_DEMAND"                 # Specifies whether the nodes are on-demand or spot instances
  disk_size       = "20"                        # Disk size (in GB) for each node in the group
  instance_types  = ["t3.medium"]               # Instance type for the nodes

  remote_access {
    ec2_ssh_key = "lucky_eks"                   # SSH key name to access the nodes
    source_security_group_ids = [aws_security_group.node.id]  # Security group for SSH access
  } 

  labels = tomap({env = "dev"})                 # Labels to apply to nodes in the group
  
  scaling_config {
    desired_size = 1                            # Desired number of nodes
    max_size     = 2                            # Maximum number of nodes
    min_size     = 1                            # Minimum number of nodes
  }

  update_config {
    max_unavailable = 1                         # Maximum number of nodes that can be unavailable during updates
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,          # Ensures this policy is attached before creating the node group
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,               # Ensures this policy is attached before creating the node group
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly, # Ensures this policy is attached before creating the node group
    aws_subnet.pub_sub1,                                               # Ensures this subnet is created before creating the node group
    aws_subnet.pub_sub2,                                               # Ensures this subnet is created before creating the node group
  ]
}
