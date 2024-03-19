resource "aws_vpc" "vpc1" {
  cidr_block = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    name = "terraform-vpc"
    env = "dev"
    team = "devops"
  }
}

resource "aws_internet_gateway" "gwy1" {
  vpc_id = aws_vpc.vpc1.id
}

