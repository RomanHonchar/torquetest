provider "aws" {
  region = "eu-central-1"
}

variable "ami_centos" {
  type = string
  default = "ami-0b14f0a2730f8cbd2"
}

resource "aws_instance" "ec2" {
  ami = var.ami_centos
  instance_type = "t2.micro"
  security_groups = [aws_security_group.webtraffic.name]
  key_name = "EC2 Test"
}

resource "aws_security_group" "webtraffic" {
  name = "Allow HTTPS"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["94.45.70.5/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

output "ec2_ip" {
  value = aws_instance.ec2.public_ip
}