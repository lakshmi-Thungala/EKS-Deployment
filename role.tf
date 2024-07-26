resource "aws_iam_role" "master" {
  name = "ed-eks-master"  # Name of the IAM role for EKS master

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  # IAM role trust policy allowing EKS to assume this role
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.master.name
  # Attaches the AmazonEKSClusterPolicy to the master IAM role
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.master.name
  # Attaches the AmazonEKSServicePolicy to the master IAM role
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.master.name
  # Attaches the AmazonEKSVPCResourceController policy to the master IAM role
}

resource "aws_iam_role" "worker" {
  name = "ed-eks-worker"  # Name of the IAM role for EKS worker nodes

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  # IAM role trust policy allowing EC2 instances (worker nodes) to assume this role
}

resource "aws_iam_policy" "autoscaler" {
  name   = "ed-eks-autoscaler-policy"  # Name of the IAM policy for autoscaling
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeTags",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
  # Policy document defining permissions for the cluster autoscaler
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker.name
  # Attaches the AmazonEKSWorkerNodePolicy to the worker IAM role
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker.name
  # Attaches the AmazonEKS_CNI_Policy to the worker IAM role
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.worker.name
  # Attaches the AmazonSSMManagedInstanceCore policy to the worker IAM role
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker.name
  # Attaches the AmazonEC2ContainerRegistryReadOnly policy to the worker IAM role
}

resource "aws_iam_role_policy_attachment" "x-ray" {
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  role       = aws_iam_role.worker.name
  # Attaches the AWSXRayDaemonWriteAccess policy to the worker IAM role
}

resource "aws_iam_role_policy_attachment" "s3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.worker.name
  # Attaches the AmazonS3ReadOnlyAccess policy to the worker IAM role
}

resource "aws_iam_role_policy_attachment" "autoscaler" {
  policy_arn = aws_iam_policy.autoscaler.arn
  role       = aws_iam_role.worker.name
  # Attaches the custom autoscaler policy to the worker IAM role
}

resource "aws_iam_instance_profile" "worker" {
  depends_on = [aws_iam_role.worker]
  name       = "ed-eks-worker-profile"  # Name of the IAM instance profile for worker nodes
  role       = aws_iam_role.worker.name
  # Creates an IAM instance profile for the worker nodes, associating it with the worker role
}
