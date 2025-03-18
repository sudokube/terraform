resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  instance_tenancy = "default"

  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "public_subnet1" {
  cidr_block = "10.0.0.0/20"
  vpc_id = aws_vpc.test_vpc.id
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "test-subnet-public1-ap-northeast-2a"
  }
}

resource "aws_subnet" "private_subnet1" {
  cidr_block = "10.0.128.0/20"
  vpc_id = aws_vpc.test_vpc.id
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "test-subnet-private1-ap-northeast-2a"
  }
}