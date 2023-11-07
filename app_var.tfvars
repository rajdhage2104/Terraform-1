# EC2 Tnstance Configuration
instances = [ {
  name  = "docker_instance"
  ami_id = "ami-0763cf792771fe1bd"
  instance_type = "t2.micro"
  key_name = "raja"
},
{
    name = "k8s_instance"
    ami_id = "ami-0763cf792771fe1bd"
    instance_type = "t2.medium"
    key_name = "raja"
} ]