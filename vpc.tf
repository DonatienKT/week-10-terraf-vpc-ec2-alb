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

# Subnets

resource "aws_subnet" "my-pub1" {
  availability_zone = "us-east-1a"
  cidr_block = "192.168.1.0/24"
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "public-subnet1"
    env = "dev"
  }
}

resource "aws_subnet" "my-pub2" {
  availability_zone = "us-east-1b"
  cidr_block = "192.168.2.0/24"
   map_public_ip_on_launch = true
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "public-subnet2"
    env = "dev"
  }
}


resource "aws_subnet" "my-priv1" {
  availability_zone = "us-east-1a"
  cidr_block = "192.168.3.0/24"
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "private-subnet1"
    env = "dev"
  }
}

resource "aws_subnet" "my-priv2" {
  availability_zone = "us-east-1b"
  cidr_block = "192.168.4.0/24"
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "private-subnet2"
    env = "dev"
  }
}

# Elastic ip and nat getway

resource "aws_eip" "eip" {
  
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.my-pub2.id
}

#Public and private route table

resource "aws_route_table" "rtpub" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gwy1.id
  }
}

resource "aws_route_table" "rtpriv" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
}

# subnet association

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.my-priv1.id
  route_table_id = aws_route_table.rtpriv.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.my-priv2.id
  route_table_id = aws_route_table.rtpriv.id
}

resource "aws_route_table_association" "rta3" {
  subnet_id = aws_subnet.my-pub1.id
  route_table_id = aws_route_table.rtpub.id
}
resource "aws_route_table_association" "rta4" {
  subnet_id = aws_subnet.my-pub2.id
  route_table_id = aws_route_table.rtpub.id
}




