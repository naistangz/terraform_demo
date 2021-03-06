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

//variable "vpc_id" {
//  default = "vpc-07e47e9d90d2076da"
//}

variable "vpcCIDRblock" {
    default = "172.32.0.0/16"
}

variable "subnetprivateCIDRblock" {
    default = "172.32.7.0/24"
}

variable "subnetpublicCIDRblock" {
    default = "172.32.8.0/24"
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

//variable "aws_instance" {
//    default = "app_instance"
//}

# IMAGES
variable "amiapp" {
    default = "ami-08617e0e0b2d50721"
}

variable "amibastion" {
  default = "ami-04e10d7d87e05a3be"
}

variable "amidb" {
  default = "ami-0f08f54c187ffa805"
}
