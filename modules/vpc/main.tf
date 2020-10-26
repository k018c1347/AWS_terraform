# アベイラリティゾーンの取得
data "aws_availability_zones" "available" {
  state = "available"
}

# Cretae VPC
resource "aws_vpc" "minami_vpc" {
  cidr_block           = var.vpc_para.cidr_block
  enable_dns_hostnames = var.vpc_para.enable_dns_hostnames
  enable_dns_support   = var.vpc_para.enable_dns_support
  tags = {
    Name = "${var.vpc_para.NameTag}-VPC"
  }
}

# Cretae IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.minami_vpc.id
  tags = {
    Name = "${var.vpc_para.NameTag}-IGW"
  }
}

# Cretae Subnets
resource "aws_subnet" "public" {
  count                   = var.vpc_para.subnet_count
  vpc_id                  = aws_vpc.minami_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.minami_vpc.cidr_block, 8, count.index) #10.2.0.0/24,10.2.1.0/24
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.vpc_para.NameTag}-PublicSubnet${count.index}"
  }
}
resource "aws_subnet" "private" {
  count                   = var.vpc_para.subnet_count
  vpc_id                  = aws_vpc.minami_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.minami_vpc.cidr_block, 8, count.index + var.vpc_para.subnet_count) #10.2.2.0/24,10.2.3.0/24
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.vpc_para.NameTag}-PrivateSubnet${count.index}"
  }
}

# Cretae RouteTables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.minami_vpc.id
  tags = {
    Name = "${var.vpc_para.NameTag}-PublicRT"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.minami_vpc.id
  tags = {
    Name = "${var.vpc_para.NameTag}-PrivateRT"
  }
}

# Cretae Route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Association RouteTables
resource "aws_route_table_association" "public" {
  count          = var.vpc_para.subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = var.vpc_para.subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}