provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA3ESU4GLGOOEM2772"
  secret_key = "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"
}

resource "aws_s3_bucket" "my-s3-bucket" {
  bucket_prefix = var.bucket_prefix
  acl = var.acl
  
   versioning {
    enabled = var.versioning
  }
  
  tags = var.tags


  

  server_side_encryption_configuration {
   rule{
    apply_server_side_encryption_by_default{
      sse_algorithm="AES256"
    }
   }
 }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name="db-terraform"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
    attribute {
      name="LockID"
      type="S"
    }
  
}




resource "aws_vpc" "vpc1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "Name" = "prod_vpc"
  }
}

resource "aws_subnet" "subnet1" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.vpc1.id
  tags = {
    "Name" = "Public_subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    "Name" = "prod_igw"
  }
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "Rta" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.subnet1.id

}
resource "aws_security_group" "sg1" {
  vpc_id = aws_vpc.vpc1.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "Public_sg1"
  }
}
resource "aws_instance" "Vm1" {
  ami                         = "ami-0c4f7023847b90238"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet1.id
  vpc_security_group_ids      = [aws_security_group.sg1.id]
  associate_public_ip_address = true
  key_name                    = "terraform"
  tags = {
    "Name" = "second_Ec2"
  }
}

