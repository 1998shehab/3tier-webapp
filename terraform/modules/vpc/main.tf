resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet1_cidr
  availability_zone ="us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet1"
  }
}


resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet2_cidr
  availability_zone ="us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet2"
  }
}



resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet1_cidr
  availability_zone ="us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet1"
  }
}



resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet2_cidr
  availability_zone ="us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet2"
  }
}



resource "aws_subnet" "private_subnet3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet3_cidr
  availability_zone ="us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet3"
  }
}


resource "aws_subnet" "private_subnet4" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet4_cidr
  availability_zone ="us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet4"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

tags = {
    Name = "public route table"
  }
}


resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

tags = {
    Name = "private route table"
  }
}



resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "private4" {
  subnet_id      = aws_subnet.private_subnet4.id
  route_table_id = aws_route_table.private.id
}




