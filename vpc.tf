
resource "aws_vpc" "VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}



resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "igw"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "subnet2"
  }
}


resource "aws_route_table" "privateRoute" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "Rtable"
  }
}
resource "aws_route_table_association" "private_subnet_route_table_association" {
  subnet_id                = aws_subnet.subnet1.id
  route_table_id           = aws_route_table.privateRoute.id
}

resource "aws_route" "privroute" {
  route_table_id         = aws_route_table.privateRoute.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat.id
  depends_on             = [aws_route_table.privateRoute]
}
resource "aws_route_table" "PUBRoute" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "PUB_RT"
  }
}
resource "aws_route_table_association" "public_subnet_route_table_association" {
  subnet_id                = aws_subnet.subnet2.id
  route_table_id           = aws_route_table.PUBRoute.id
}

resource "aws_route" "pubroute" {
  route_table_id         = aws_route_table.PUBRoute.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table.PUBRoute]
}
### Security group ###



resource "aws_eip" "eip" {
  vpc      = true
  tags = {
    Name = "EIP"
  }
}


resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.subnet2.id
  allocation_id = aws_eip.eip.id
}

resource "aws_security_group" "sg" {
  name        = "Allow_all2"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.VPC.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
