# VPC
resource "aws_vpc" "project" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  instance_tenancy      = "default"

  tags = {
    Name = "${var.project}-vpc"
  }
}

# Subnets
resource "aws_subnet" "subnet_public1" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-subnet-public1-${var.availability_zone[0]}"
  }
}

resource "aws_subnet" "subnet_public2" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-subnet-public2-${var.availability_zone[1]}"
  }
}

resource "aws_subnet" "subnet_public3" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.32.0/20"
  availability_zone       = var.availability_zone[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-subnet-public3-${var.availability_zone[2]}"
  }
}

resource "aws_subnet" "subnet_private1" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.128.0/20"
  availability_zone       = var.availability_zone[0]

  tags = {
    Name = "${var.project}-subnet-private1-${var.availability_zone[0]}"
  }
}

resource "aws_subnet" "subnet_private2" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.144.0/20"
  availability_zone       = var.availability_zone[1]

  tags = {
    Name = "${var.project}-subnet-private2-${var.availability_zone[1]}"
  }
}

resource "aws_subnet" "subnet_private3" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.160.0/20"
  availability_zone       = var.availability_zone[2]

  tags = {
    Name = "${var.project}-subnet-private3-${var.availability_zone[2]}"
  }
}

# VPC endpoints for Systems Manager
resource "aws_vpc_endpoint" "vpce_ec2messages" {
  vpc_id              = aws_vpc.project.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  subnet_ids          = [aws_subnet.subnet_private1.id]
  security_group_ids  = [aws_security_group.sg_ssm.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "vpce_ssm" {
  vpc_id              = aws_vpc.project.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.region}.ssm"
  subnet_ids          = [aws_subnet.subnet_private1.id]
  security_group_ids  = [aws_security_group.sg_ssm.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "vpce_ssmmessages" {
  vpc_id              = aws_vpc.project.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  subnet_ids          = [aws_subnet.subnet_private1.id]
  security_group_ids  = [aws_security_group.sg_ssm.id]
  private_dns_enabled = true
}

# Public Route Table
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.project.id

  tags = {
    Name = "${var.project}-rtb-public"
  }
}

resource "aws_route" "rtb_public" {
  route_table_id          = aws_route_table.rtb_public.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "subnet_public" {
  route_table_id  = aws_route_table.rtb_public.id
  subnet_id       = aws_subnet.subnet_public1.id
}

# # Private Route Table
# resource "aws_route_table" "rtb_private" {
#   vpc_id = aws_vpc.project.id

#   tags = {
#     Name = "${var.project}-rtb-private"
#   }
# }

# resource "aws_route" "rtb_private" {
#   route_table_id          = aws_route_table.rtb_private.id
#   destination_cidr_block  = "0.0.0.0/0"
#   nat_gateway_id          = aws_nat_gateway.nat_public.id
# }

# resource "aws_route_table_association" "subnet_private1" {
#   route_table_id  = aws_route_table.rtb_private.id
#   subnet_id       = aws_subnet.subnet_private1.id
# }

# resource "aws_route_table_association" "subnet_private2" {
#   route_table_id  = aws_route_table.rtb_private.id
#   subnet_id       = aws_subnet.subnet_private2.id
# }

# resource "aws_route_table_association" "subnet_private3" {
#   route_table_id  = aws_route_table.rtb_private.id
#   subnet_id       = aws_subnet.subnet_private3.id
# }

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "${var.project}-igw"
  }
}

resource "aws_internet_gateway_attachment" "igw" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.project.id
}

# Elastic IP Address
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project}-eip-${var.availability_zone[0]}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway
resource "aws_nat_gateway" "nat_public" {
  subnet_id     = aws_subnet.subnet_public1.id
  allocation_id = aws_eip.eip.id

  tags = {
    Name = "${var.project}-nat-public-${var.availability_zone[0]}"
  }
}