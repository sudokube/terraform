resource "aws_instance" "bastion" {
  ami   = "ami-062cddb9d94dcf95d"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id = aws_subnet.public_subnet1.id
  key_name = aws_key_pair.public.key_name

  tags = {
    Name = "test-instance-bastion-ap-northeast-2a"
  }
}

resource "aws_instance" "private" {
  ami   = "ami-0077297a838d6761d"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.private.id]
  subnet_id = aws_subnet.private_subnet1.id
  key_name = aws_key_pair.public.key_name

  tags = {
    Name = "test-instance-private2-ap-northeast-2a"
  }
}

resource "aws_security_group" "bastion" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.bastion.id

  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_security_group" "private" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "bastion_access" {
  security_group_id = aws_security_group.private.id

  referenced_security_group_id = aws_security_group.bastion.id
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
}