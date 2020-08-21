# This will launch an AMI on AWS
# What do we want to do and where would we like to create the instance 

# Syntax for terraform is similar to json - we use { to write block of code }

provider "aws" {
# which region do we have the AMI available
  region     = var.region
}

# Creating the VPC
resource "aws_vpc" "Eng67_Anais_Terraform_VPC" {
  cidr_block    = var.vpcCIDRblock

  tags = {
    Name = "Eng67.Anais.Terraform.VPC"
  }
} # end Creating VPC

# Creating APP instance - launch an EC2 Instance from the AMI
resource "aws_instance" "app_instance" {
          ami           = var.amiapp
# what type of ec2 instance we want to create = t2.micro
          instance_type = "t2.micro"
//          vpc_id                  = aws_vpc.Eng67_Anais_Terraform_VPC.id
          subnet_id              = aws_subnet.public_subnet.id
          vpc_security_group_ids = [aws_security_group.app_sg.id]
# public IP
          associate_public_ip_address = true
          tags = {
            Name = "Eng67.Anais.terraform.app"

          }

} # end Creating APP instance

# Creating DB instance
resource "aws_instance" "db_instance" {
          ami           = var.amidb
# what type of ec2 instance we want to create = t2.micro
          instance_type = "t2.micro"
//          vpc_id                   = aws_vpc.Eng67_Anais_Terraform_VPC.id
          subnet_id               = aws_subnet.private_subnet.id
          vpc_security_group_ids   = [aws_security_group.db_sg.id]
          associate_public_ip_address = true
          tags = {
            Name = "Eng67.Anais.terraform.db"

          }
} # end Creating DB instance

# Creating public subnet block of code
resource "aws_subnet" "public_subnet" {

  vpc_id                 = aws_vpc.Eng67_Anais_Terraform_VPC.id
  cidr_block              = var.subnetpublicCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone


tags = {
  Name = "Eng67.Anais.Terraform.Subnet.Public"
}

} # end Creating Public Subnet


# Creating a private subnet block of code
resource "aws_subnet" "private_subnet" {

  vpc_id                  = aws_vpc.Eng67_Anais_Terraform_VPC.id
  cidr_block              = var.subnetprivateCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone
tags = {
  Name = "Eng67.Anais.Terraform.Subnet.Private"
}

} # end Creating Private Subnet

# Create a app security group and attach it to the VPC
resource "aws_security_group" "app_sg" {
  vpc_id                  = aws_vpc.Eng67_Anais_Terraform_VPC.id
  name                    = "Eng67.Anais.app.SG.terraform"
  description             = "Eng67.Anais.app.SG.terraform"


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
  Name = "Eng67.Anais.app.SG"
  Description = "Security group for app"
}

} # end creating app security group

# Creating db security group
resource "aws_security_group" "db_sg" {
  vpc_id        = aws_vpc.Eng67_Anais_Terraform_VPC.id
  name          = "Eng67.Anais.DBSG.terraform"
  description   = "DB security group"


  # Allow ingress from my IP through SSH
  ingress {
    description = "Allowing app access to DB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  # Allow egress of all ports
  egress {
    cidr_blocks = var.egressCIDRblock
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name        = "Eng67.Anais.DBSG.terraform"
    Description = "Eng67.Anais.DBSG.terraform"
  }
} # end db security group

# Create internet gateway
resource "aws_internet_gateway" "terraform_IGW" {
  vpc_id = aws_vpc.Eng67_Anais_Terraform_VPC.id
  tags = {
    Name = "Eng67.Anais.IGW"
  }
}

# Route table public
resource "aws_route_table" "public_route_table" {
  vpc_id    = aws_vpc.Eng67_Anais_Terraform_VPC.id
//  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = "Eng67.Anais.Terraform.Route.Public"
  }
}

# Creating the Internet Access
resource "aws_route" "Internet_access" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id = aws_internet_gateway.terraform_IGW.id
}

# Associating the route table with the subnet
resource "aws_route_table_association" "route_table_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet.id
}

//# Creating Private subnet Network Access Control List NACL
//resource "aws_network_acl" "private_nacl" {
//  vpc_id        = aws_vpc.Eng67_Anais_Terraform_VPC.id
//  subnet_ids    = [aws_subnet.private_subnet.id]
//
//  # ingress rules
//  ingress {
//    action       = "allow"
//    from_port    = 27017
//    protocol     = "tcp"
//    rule_no      = 1
//    to_port      = 27017
//    cidr_block   = var.subnetpublicCIDRblock
//
//  }
//
//  ingress {
//    action     = "allow"
//    from_port  = 22
//    protocol   = "tcp"
//    rule_no    = 100
//    to_port    = 22
//    cidr_block = var.subnetpublicCIDRblock
//  }
//
//  ingress {
//    action = "allow"
//    from_port = 0
//    protocol = ""
//    rule_no = 200
//    to_port = 0
//    cidr_block = var.ingressCIDRblock
//  }
//
//  # egress rule
//  egress {
//    action    = "allow"
//    from_port = 0
//    protocol  = "all"
//    rule_no   = 200
//    to_port   = 0
//  }
//
//  # egress rule
//
//  egress {
//    action     = "allow"
//    from_port  = 0
//    to_port    = 0
//    rule_no    = 1
//    protocol   = "all"
//    cidr_block = var.subnetpublicCIDRblock
//  }
//
//  tags = {
//    Name = "Eng67.Anais.terraform.NACL.private"
//  }
//}
//
//
//# Public NACL
//resource "aws_network_acl" "public_nacl" {
//  vpc_id    = aws_vpc.Eng67_Anais_Terraform_VPC.id
//  subnet_id = aws_subnet.public_subnet.id
//
//  # HTTP (80)
//  ingress {
//    rule_no    = 100
//    protocol   = "tcp"
//    from_port  = 80
//    to_port    = 80
//    action     = "allow"
//    cidr_block = var.ingressCIDRblock
//  }
//
//  # HTTPS (443)
//  ingress {
//    action = "allow"
//    from_port = 443
//    protocol = "tcp"
//    rule_no = 110
//    to_port = 443
//    cidr_block = var.ingressCIDRblock
//  }
//
//
//  # Custom TCP Rule
//  ingress {
//    action = "allow"
//    from_port = 1024
//    protocol = "tcp"
//    rule_no = 120
//    to_port = 65535
//  }
//
//  # Custom TCP Rule
//  ingress {
//    action = "allow"
//    from_port = 27017
//    protocol = "tcp"
//    rule_no = 140
//    to_port = 27017
//    cidr_block = var.vpcCIDRblock
//  }
//
//  # Custom TCP rule
//  ingress {
//    action = "allow"
//    from_port = 1024
//    protocol = "tcp"
//    rule_no = 141
//    to_port = 65535
//    cidr_block = var.vpcCIDRblock
//  }
//
//  egress {
//    action = "allow"
//    from_port = 0
//    protocol = "tcp"
//    rule_no = 100
//    to_port = 65535
//  }
//
//  tags = {
//    Name  = "Eng67.Anais.terraform.NACL.public"
//  }
//} # End creating public NACL

