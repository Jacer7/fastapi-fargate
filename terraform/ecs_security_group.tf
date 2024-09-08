resource "aws_security_group" "ecs_web_access_sg" {
  name        = "ecs_web_access_sg"
  description = "Allow inbound traffic on port 8000 and outbound traffic to 0.0.0.0/0"
  vpc_id      = data.aws_vpc.default.id # Reference the default VPC or your specific VPC

  # Inbound rule to allow traffic on port 8000
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows traffic from any IP address
  }

  # Outbound rule to allow all traffic to any destination
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allows outbound traffic to any IP address
  }

  tags = merge(local.common_tags, {
    Name = "ecs_web_access_sg"
  })
}

