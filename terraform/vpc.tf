# Define the VPC
# Create VPC 
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    name = "main_vpc"
  }
}

# Create two subnets
resource "aws_subnet" "main_subnet_a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "main_subnet_b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
}

# Define internet gateway
resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    name = "main_internet_gateway"
  }
}

# Define route table
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_internet_gateway.id
  }
}

resource "aws_route_table_association" "main_subnet_a_route" {
  subnet_id      = aws_subnet.main_subnet_a.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table_association" "main_subnet_b_route" {
  subnet_id      = aws_subnet.main_subnet_b.id
  route_table_id = aws_route_table.main_route_table.id
}

# Define security group
resource "aws_security_group" "main_security_group" {
  name   = "ecs-security-group"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "any"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
