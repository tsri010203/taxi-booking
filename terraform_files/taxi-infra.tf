provider "aws" {
  region = "ap-south-1"
}
data "aws_vpc" "default" {
  default = true
}

# Get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_instance" "ansible" {
    ami                     = "ami-07f07a6e1060cd2a8"
    instance_type           = "t2.medium"
    key_name                = "taxi"
    vpc_security_group_ids  = [aws_security_group.demo-sg.id]
    //subnet_id               = "subnet-077471d3c705ea769"
    tags                    = {
        Name      = "ansible"
    }
}
    


resource "aws_instance" "jenkins_master" {
  ami                        = "ami-07f07a6e1060cd2a8"
  instance_type              = "t2.medium"
  key_name                   = "taxi"
  vpc_security_group_ids     = [aws_security_group.demo-sg.id]
  
  tags                       = {
    Name = "jenkins-master"
  }
  

}

resource "aws_instance" "jenkins_slave" {
  ami                        = "ami-07f07a6e1060cd2a8"
  instance_type              = "t2.medium"
  key_name                   = "taxi"
  vpc_security_group_ids     = [aws_security_group.demo-sg.id]
  
  tags                       = {
    Name = "jenkins-slave"
  }
  
}


resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"

  
  ingress {
    description      = "SHH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
    description      = "Jenkins port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
    description      = "Container  port"
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
    description      = "https  port"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
    description      = "http  port"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-port"

  }
}
