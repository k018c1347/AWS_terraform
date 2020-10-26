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
  count  = var.vpc_para.subnet_count
  vpc_id = aws_vpc.minami_vpc.id
  tags = {
    Name = "${var.vpc_para.NameTag}-PrivateRT"
  }
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
  route_table_id = aws_route_table.private[count.index].id
}

# Cretae Route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private" {
  count                  = var.vpc_para.subnet_count
  route_table_id         = aws_route_table.private[count.index].id
  gateway_id             = aws_nat_gateway.nat_gateway[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}

# NAT

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.vpc_para.subnet_count
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.private[count.index].id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat_gateway" {
  count      = var.vpc_para.subnet_count
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

/*
# Cretae Subnets
resource "aws_subnet" "public" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.minami_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.minami_vpc.cidr_block, 8, each.value)
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "${each.key}-PublicSubnet"
  }
}

resource "aws_subnet" "private" {
  for_each = var.subnets
  vpc_id   = aws_vpc.minami_vpc.id
  //Cidr_blackで改善の余地あり
  cidr_block              = cidrsubnet(aws_vpc.minami_vpc.cidr_block, 8, each.value + 3)
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = "${each.key}-PrivateSubnet"
  }

}
*/

/*　汎用的な　for_each　利用
variable "subnets" {
  default = {
    "test-subnet-1a" = {
      cidr = "10.0.1.0/24"
      az   = "ap-northeast-1a"
    }
    "test-subnet-1c" = {
      cidr = "10.0.2.0/24"
      az   = "ap-northeast-1c"
    }
  }
}

resource "aws_subnet" "public" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.minami_vpc.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true
  availability_zone       = each.value.az
  tags = {
    Name = "${var.subnets.key}-PublicSubnet$"
  }
}

*/
