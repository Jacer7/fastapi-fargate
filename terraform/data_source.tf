# Retrieve the default VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "selected_subnet" {
  id = "subnet-067e526fdc6b6e07f"  # Your provided subnet ID
}

# Retrieve the default security group within the default VPC
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id # Ensures the default SG is in the correct VPC
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

