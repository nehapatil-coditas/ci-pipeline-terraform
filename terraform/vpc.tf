# VPC
resource "aws_vpc" "demovpc" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = "Demo VPC"
  }
}

# Subnets
# Creating 1st subnet 
resource "aws_subnet" "demosubnet" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = var.subnet_cidr
  #tfsec:ignore:aws-ec2-no-public-ip-subnet
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Demo subnet"
  }
}
# Creating 2nd subnet 
resource "aws_subnet" "demosubnet1" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = var.subnet1_cidr
  #tfsec:ignore:aws-ec2-no-public-ip-subnet
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "Demo subnet 1"
  }
}

# Creating internet gateway
resource "aws_internet_gateway" "demogateway" {
  vpc_id = aws_vpc.demovpc.id
}

# Creating Route Table
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.demovpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demogateway.id
  }
  tags = {
    Name = "Route to internet"
  }
}

# Routetable Asscociation 
resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.demosubnet.id
  route_table_id = aws_route_table.route.id
}
resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.demosubnet1.id
  route_table_id = aws_route_table.route.id
}

