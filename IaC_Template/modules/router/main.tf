######################################################
# Route the public subnet traffic through
# the Internet Gateway
######################################################
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Public route table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "public" {
  count = "${length(var.availability_zones)}"

  subnet_id      = "${element(var.public_subnet_ids, count.index)}"
  route_table_id = aws_route_table.public.id
}


######################################################
# Create a new route table for private subnets
# Route non-local traffic through the NAT gateway
# to the Internet
######################################################
resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = var.vpc_id

  tags = {
    Name = "Private - ${var.availability_zones[count.index]}"
  }
}

resource "aws_route" "nat_gateway" {
  count                  = length(var.availability_zones)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[count.index]
}

# Associations for both private_a and private_b
resource "aws_route_table_association" "private_a" {
  count          = length(var.availability_zones)
  subnet_id      = var.private_subnet_ids_a[count.index]
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "private_b" {
  count          = length(var.availability_zones)
  subnet_id      = var.private_subnet_ids_b[count.index]
  route_table_id = aws_route_table.private[count.index].id
}