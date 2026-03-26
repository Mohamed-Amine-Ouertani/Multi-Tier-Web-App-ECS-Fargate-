resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public - ${var.availability_zones[count.index]}"
  }
}


resource "aws_subnet" "private_a" {
  count             = length(var.availability_zones)
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.cidr_block, 9, (count.index * 2) + (length(var.availability_zones) * 2))
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "Private route table A - ${element(var.availability_zones, count.index)}"
  }
}

resource "aws_subnet" "private_b" {
  count             = length(var.availability_zones)
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.cidr_block, 9, (count.index * 2) + (length(var.availability_zones) * 2 + 1))
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "Private route table B - ${element(var.availability_zones, count.index)}"
  }
}