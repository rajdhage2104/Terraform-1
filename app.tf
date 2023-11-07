provider "aws" {
  region = "ap-south-1"
}

#Creating VPC
resource "aws_vpc" "App_VPC" {
  cidr_block = "10.0.0.0/20"
  tags = {
    name = "student_app"
  }
}

#Creating Subnets
resource "aws_subnet" "Stu_subnet1" {
  vpc_id = aws_vpc.App_VPC.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "Stu_subnet2" {
  vpc_id = aws_vpc.App_VPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

#Securtiy Group
resource "aws_security_group" "MySG" {
  name  = "my_sg"
  vpc_id = aws_vpc.App_VPC.id
  #Ingress rules go here...
  ingress = [
    {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = true
    },
    {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = true
    }, 
  ]
  #no egress rule defined so, AWS will allow all outbound traffic by default
  tags = {
    name = "SG_group1"
  }
}

#Internet Gateway 
resource "aws_internet_gateway" "IGW1" {
  vpc_id = aws_vpc.App_VPC.id
}

#Route Tables
resource "aws_route_table" "RT_app" {
 vpc_id = aws_vpc.App_VPC.id
}

#Route to IGW
resource "aws_route" "route_to_IGW" {
  route_table_id = aws_route_table.RT_app.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.IGW1.id
}

#route to Subnets
resource "aws_route_table_association" "subnet_association" {
  subnet_id = aws_subnet.Stu_subnet1.id
  route_table_id = aws_route_table.RT_app.id
  
}
resource "aws_route_table_association" "subnet_association2" {
  subnet_id = aws_subnet.Stu_subnet2.id
  route_table_id = aws_route_table.RT_app.id
}

#Launch an EC2 Instance
resource "aws_instance" "my_instance" {
  for_each = {for i, instance in var.instances : i => instance}
  ami = each.value.ami_id 
  instance_type = each.value.instance_type
  security_groups = [aws_security_group.MySG.id]
  key_name = each.value.key_name

  tags = {
    name = each.value.name
  }
}