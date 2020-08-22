# Infrastructure as code with Terraform

**Contents**
- [x] [Infrastructure as Code](#infrastructure-as-code)
- [x] [Orchestration and Configuration Management](#what-is-the-difference-between-orchestration-and-configuration-management)
- [x] [Configuration Management Tools](#configuration-management-tools)
- [x] [Orchestration Tools](#orchestration-tools)
- [x] [What is Terraform](#what-is-terraform)
- [x] [Why Terraform?](#why-terraform)
- [x] [Terraform Commands](#terraform-commands)
- [x] [Creating an AWS Subnet and Security Group using Terraform](#creating-an-aws-subnet-and-security-group-using-terraform)

## Infrastructure as code 
```bash
Configuration Management 
Orchestration Management 
```

## Recap - What is IaC?
- IaC is a method to provision and manage IT infrastructure through the use of source code, rather than through standard operating procedures and manual processes.
- It is the process of treating our servers, databases, networks, and other infrastructure like software.
- This code can help us configure and deploy infrastructure components quickly and consistently and significantly reduces time.
- IaC helps us to automate the infrastructure deployment process in a repeatable, consistent manner

## Why is IaC is important?
- Historically, sysadmins used to deploy infrastructure manually including every server, every route table entry, every database configuration, every load balancer was set up manually.
- DevOps, changed this by treating these configurations like software and setting up through Infrastructure as Code (IaC).
- IaC alleviates the issues and cost implications of investing in hardware as well as the the costs that come with human capital and real estate.
- IaC allows to spin up servers, databases, etc very quickly, which would address the [scalability](#scalability), [high availability](#availability) and [agility](#agility) problems.  
- IaC allows for consistency, due to code reusability 

## Scalability 
- Being able to adapt to changes over time and meet market demands
- Market demands are never static, so automating the management of environments is useful to meet unexpected changes such as a spike in traffic
- AWS provides monitoring services to detect changes such as CPU usage, expiring data points and automatically spins up new servers.

## Availability 
- High available systems mean that operations that continue as normal
- Any downtime will impact this, so it is important to maintain the system setup and plan to mitigate potential problems before they arise.
- You can use Amazon EC2 auto scaling to maintain a minimum number of running instances for your application at all times so when traffic increases, you can use Elastic Load Balancing to distribute incoming traffic across these EC2 instances, thereby increasing the availability of your application
- You can also place your instances in multiple Availability Zones in the event if one availability zone experiences an outage.

## Agility 
- Agility means the ability to change course, according to changes in our environment
- This means inspecting and adapting such as the ability to shorten lead times, responding to changing circumstances, quickly and inexpensively and delivering in rapid cycles
- Being agile also means risk mitigating. Market demands are never static, customers are fickle, macro economic circumstances can impact decisions and financial performance. Being technologically agile is key to being competitive and flexible. 

## What is the difference between orchestration and configuration management?
Orchestration|Configuration
----|----
Arranging or coordinating multiple systems|Configuring is about bringing consistency
Designed to automate deployment of servers| Systematically handling changes to a system in a way that it maintains integrity over time
--|Consistency of systems and hardware
--|Configure software and systems that has already been provisioned
Terraform to deploy underlying infrastructure e.g network topology (VPCs, subnets, route tables), load balancers|Ansible deploys our apps on top of those servers

## Configuration management tools 
```bash
Chef
Puppet 
Ansible
SaltStack
```

## Orchestration Tools 
```bash
Terraform
Openstack Heat 
AWS Cloudformation
Kubernetes
```

## What is Terraform?
- A tool for developing, changing, versioning infrastructure safely and efficiently 
- Terraform can manage existing and popular service providers as well as custom in-house solutions.
- Terraform provides support for immutable infrastructure (Immutable images are static and any updates must generate a new version of the base image)

## Why terraform
- Simple json syntax
- Open source
- Able to provision infrastructure using on premise computer without using AWS Services, therefore it is cost effective
- Code re-usability, allowing to make changes faster. 
- Every aspect of a cloud provider's platform is accessible without scripting in an API. 
- Terraform's `plan` command lets you see what changes you're about to apply before you apply them
- Terraform allows you to rebuild/change and track changes to infrastructure with ease.
- Terraform enables you to implement all kinds of coding principles like having your code in source control and the ability to write automated tests.
- Uses **declarative statements**, meaning you declare how you want your IT infrastructure to be configured and then Terraform maps out the dependencies and builds everything for you.


### Terraform commands

```tf
terraform init
terraform plan - checks the steps inside the code and lists the successes and errors
terraform apply - will implement the code - deploy the infrastructure
```

---

# Creating an AWS Subnet and security group using Terraform

1. `main.tf`
```hcl-terraform
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
} # End creating IGW

# Route table public
resource "aws_route_table" "public_route_table" {
  vpc_id    = aws_vpc.Eng67_Anais_Terraform_VPC.id
  tags = {
    Name = "Eng67.Anais.Terraform.Route.Public"
  }
} # End creating route table

# Creating the Internet Access
resource "aws_route" "Internet_access" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id = aws_internet_gateway.terraform_IGW.id
} # End creating internet access

# Associating the route table with the subnet
resource "aws_route_table_association" "route_table_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet.id
} # end creating route table association
```

2. Create variables file `variables.tf` example:
```hcl-terraform

variable "availabilityZone" {
  default = "eu-west-1b"
}

variable "vpc_id" {
  default = "vpc-07e47e9d90d2076da"
}

variable "vpcCIDRblock" {
    default = "172.31.0.0/16"
}

variable "subnetCIDRblock" {
    default = "172.31.7.0/24"
}
```

3. Create template in terraform `init.sh.tpl`:
```hcl-terraform
#!/bin/bash

cd /home/ubuntu/app
export DB_HOST=${db_host}
. ~/.bashrc
node seeds/seed.js
pm2 stop app.js
npm install
pm2 start app.js
```
Since we have launched the instances using pre-configured AMI's it will also contain files from the instance through which we generated the image. The app folder from our app instance will also be present in our newly created instance.