output "endpoint" {
  value = aws_eks_cluster.eks.endpoint  # The endpoint URL of the EKS cluster's API server
}