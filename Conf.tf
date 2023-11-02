provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "TF_instance" {
  ami = "ami-0763cf792771fe1bd"
  instance_type = "t2.micro"
  key_name = "mykey100"
  vpc_security_group_ids = ["sg-076de74cf330b6063"]
  tags = {
    name = "new_instance"
    env = "dev"
  }
}