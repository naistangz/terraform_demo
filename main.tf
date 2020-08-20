# This will launch an AMI on AWS
# What do we want to do and where would we like to create the instance 

# Syntax for terraform is similar to json - we use { to write block of code }

provider "aws" {
# which region do we have the AMI available
  region = var.region

}

# Creating an instance - launch an EC2 Instance from the AMI
resource "aws_instance" "app_instance" {
          ami          = "ami-08617e0e0b2d50721"
# what type of ec2 instance we want to create = t2.micro
          instance_type = "t2.micro"

# public IP
          associate_public_ip_address = true
          tags = {
            Name = "Eng67.Anais.terraform.app"

          }

} # end Creating an instance


# Creating a subnet block of code and attaching this to DevOpsStudent VPC
resource "aws_subnet" "public_subnet" {

  cidr_block              = var.subnetCIDRblock
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone
tags = {
  Name = "Eng67.Anais.Ansible.Subnet.Public"
}

} # end Creating Public Subnet

# Create a security group and attach it to the VPC
resource "aws_security_group" "public_sg" {
  vpc_id                  = var.vpc_id
  name                    = "Eng67.Anais.public.SG"
  description             = "Eng67.Anais.public.SG.terraform"

  # Allow ingress of port 80
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }


  # Allow egress of all ports
  egress {
    cidr_blocks = var.egressCIDRblock
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

tags = {
  Name = "Eng67.Anais.public.SG"
  Description = "Eng67.Anais.public.SG.terraform"
}

} # end creating public sg
