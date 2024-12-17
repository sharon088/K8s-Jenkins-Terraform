resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC"
  }
}

resource "aws_subnet" "public" {
  count               = length(var.public_subnet_cidr)
  vpc_id              = aws_vpc.vpc.id
  cidr_block          = var.public_subnet_cidr[count.index]
  availability_zone   = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count               = length(var.private_subnet_cidr)
  vpc_id              = aws_vpc.vpc.id
  cidr_block          = var.private_subnet_cidr[count.index]
  availability_zone   = var.azs[count.index]

  tags = {
    Name = "Private subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_eip" "nat_eip" {
  count   = length(aws_subnet.public)
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count           = length(aws_subnet.public)
  allocation_id   = aws_eip.nat_eip[count.index].id
  subnet_id       = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-gateway-${count.index}"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  count           = length(aws_subnet.public)
  subnet_id       = aws_subnet.public[count.index].id
  route_table_id  = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  count = length(aws_subnet.private)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
}

resource "aws_route_table_association" "private_assoc" {
  count           = length(aws_subnet.private)
  subnet_id       = aws_subnet.private[count.index].id
  route_table_id  = aws_route_table.private_rt[count.index].id
}