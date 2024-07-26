resource "aws_eks_cluster" "eks" {
  name = "ed-eks-01"              # Name of the EKS cluster
  version = "1.22"                # Kubernetes version for the cluster
  role_arn = aws_iam_role.master.arn  # ARN of the IAM role that EKS uses to create AWS resources

  vpc_config {
    subnet_ids = [aws_subnet.pub_sub1.id, aws_subnet.pub_sub2.id]  # Subnets for the EKS cluster
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,         # Ensures this policy is attached before creating the cluster
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,         # Ensures this policy is attached before creating the cluster
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController, # Ensures this policy is attached before creating the cluster
    aws_subnet.pub_sub1,                                           # Ensures this subnet is created before creating the cluster
    aws_subnet.pub_sub2,                                           # Ensures this subnet is created before creating the cluster
  ]
}
