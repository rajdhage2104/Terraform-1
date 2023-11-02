provider "aws" {
  region = "ap-south-1"
}
#VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/20"
  tags = {
    name = My_vpc
  }
}
#Subnet 
resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}
#Security Group
resource "aws_security_group" "my-sg" {
  name = "sg1"
  vpc_id = aws_vpc.my_vpc.id
  ingress = [
    {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ]
  egress = [
    {
    description = "for all outgoing traffics"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ]
}
# Internet Gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my_vpc.id
}
# Route Table
resource "aws_route_table" "my_route" {
    vpc_id = aws_vpc.my_vpc.id
}
# Route to IGW
resource "aws_route" "route_to_IGW" {
  route_table_id = aws_route_table.my_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id
}
#Route to subnet
resource "aws_route_table_association" "subnet_association" {
  subnet_id = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route.id
}
#EC2 Instance
resource "aws_instance" "TF_instance" {
  ami = "ami-0763cf792771fe1bd"
  instance_type = "t2.micro"
  key_name = "mykey100"
  vpc_security_group_ids = aws_vpc.my_vpc.id
  subnet_id = aws_subnet.my_subnet.id
  security_groups = [ aws_security_group.my-sg.name ]
  tags = {
    name = "new_instance"
    env = "dev"
  }
}