# 1. Elastic IP for NAT
resource "aws_eip" "nat" {
  domain = "vpc"
}

# 2. NAT Gateway
# We put it in the FIRST public subnet found in our list
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id 
  tags = { Name = "${var.project_name}-nat" }

  depends_on = [aws_internet_gateway.gw]
}

# 3. Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }
  tags = { Name = "${var.project_name}-private-rt" }
}

# 4. Associate ALL Private Subnets with NAT
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
