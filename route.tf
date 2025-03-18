resource "aws_route_table" "test_rtb_public" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test-rtb-public"
  }
}

resource "aws_route" "test_rtb_public" {
  route_table_id = aws_route_table.test_rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.test_igw.id
}

resource "aws_route_table_association" "test_rtb_public" {
  route_table_id = aws_route_table.test_rtb_public.id
  subnet_id = aws_subnet.public_subnet1.id 
}

# resource "aws_route_table_association" "test_rtb_public_2" {
#   route_table_id = aws_route_table.test_rtb_public.id
#   subnet_id = aws_subnet.public_subnet2.id 
# }

resource "aws_route_table" "test_rtb_private1" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test-rtb-private1-ap-northeast-2a"
  }
}

resource "aws_route" "test_rtb_private1" {
  route_table_id = aws_route_table.test_rtb_private1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.test_nat1.id
}

resource "aws_route_table_association" "test_rtb_private1" {
  route_table_id = aws_route_table.test_rtb_private1.id
  subnet_id = aws_subnet.private_subnet1.id 
}

# resource "aws_route_table" "test_rtb_private2" {
#   vpc_id = aws_vpc.test_vpc.id

#   tags = {
#     Name = "test-rtb-private2-ap-northeast-2b"
#   }
# }

# resource "aws_route" "test_rtb_private2" {
#   route_table_id = aws_route_table.test_rtb_private2.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.test_nat2.id
# }

# resource "aws_route_table_association" "test_rtb_private2" {
#   route_table_id = aws_route_table.test_rtb_private2.id
#   subnet_id = aws_subnet.private_subnet2.id 
# }