resource "aws_security_group" "node" {
  name        = "ed-eks-node-sg"            # Name of the security group
  description = "Allow ssh inbound traffic" # Description of the security group
  vpc_id      = aws_vpc.vpc.id              # VPC in which the security group will be created

  ingress {
    description = "ssh access to public"    # Description of the ingress rule
    from_port   = 22                        # Start of port range for the ingress rule (SSH port)
    to_port     = 22                        # End of port range for the ingress rule (SSH port)
    protocol    = "tcp"                     # Protocol for the ingress rule (TCP)
    cidr_blocks = ["0.0.0.0/0"]             # IP range allowed to access the instances (open to the public)
  }

  egress {
    from_port   = 0                         # Start of port range for the egress rule (all ports)
    to_port     = 0                         # End of port range for the egress rule (all ports)
    protocol    = "-1"                      # Protocol for the egress rule (all protocols)
    cidr_blocks = ["0.0.0.0/0"]             # IP range allowed for outbound traffic (open to the public)
  }
}
