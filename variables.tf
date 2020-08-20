variable "access_key" {
  default = "ec2_access_key"
}

variable "secret_key" {
  default = "ec2_secret_key"
}

variable "region" {
  default = "eu-west-1"
}


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

variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}

variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}

variable "aws_instance" {
    default = "app_instance"
}

variable "ami" {
    default = "ami-08617e0e0b2d50721"
}
