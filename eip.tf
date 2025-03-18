resource "aws_eip" "test_eip" {
  domain = "vpc"

  tags = {
    Name = "test-eip-ap-northeast-2a"
  }

  depends_on = [ aws_internet_gateway.test_igw ]
}

resource "aws_nat_gateway" "test_nat1" {
  subnet_id = aws_subnet.public_subnet1.id
  allocation_id = aws_eip.test_eip.id

  tags = {
    Name = "test-nat-public1-ap-northeast-2a"
  }
}

resource "aws_key_pair" "public" {
  public_key = tls_private_key.public.public_key_openssh
}

resource "tls_private_key" "public" {
  algorithm = "ED25519"
}

resource "local_file" "public" {
  content = tls_private_key.public.private_key_openssh
  filename = "public.pem"
}

resource "aws_key_pair" "private" {
  public_key = tls_private_key.private.public_key_openssh
}

resource "tls_private_key" "private" {
  algorithm = "ED25519"
}

resource "local_file" "private" {
  content = tls_private_key.private.private_key_openssh
  filename = "private.pem"
}