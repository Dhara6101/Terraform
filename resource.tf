resource "aws_instance" "my_instance" {
    ami           = "ami-07619059e86eaaaa2"
    instance_type = "t2.micro"
   
    tags = {
      Name = "instance"  
    }
}
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Security group for HTTP and HTTPS traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere for HTTP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere for HTTPS
  }
}
resource  "aws_vpc" "vpc" { # we creating resuorce i am gooing to create aws vpc resource that is what aws_vpc
    cidr_block                       = "10.0.0.0/16"
    instance_tenancy                 = "default"
    enable_dns_hostnames             = true
    assign_generated_ipv6_cidr_block = false 
    tags = {
      Name = "terraformvpc"
    }
  
}
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
    tags ={
        Name ="terraform_igw"
    }  
}
resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-1a"
    map_public_ip_on_launch = true
}
resource "aws_route_table" "public-route-table" {
  vpc_id =  aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}
resource "aws_route_table_association" "public-subnet-rout-table-association" {
   subnet_id = aws_subnet.public-subnet.id
   route_table_id = aws_route_table.public-route-table.id
}
resource "aws_subnet" "private-subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-west-1b"
    map_public_ip_on_launch = false
    tags = {
      Nmae ="terrform-private-subnet"
    }
  
}

  
