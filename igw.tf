resource "aws_internet_gateway" "test_igw" {
  tags = {
    Name = "test-igw"
  }
}

resource "aws_internet_gateway_attachment" "test_igw_attachment" {
  internet_gateway_id = aws_internet_gateway.test_igw.id
  vpc_id = aws_vpc.test_vpc.id
}