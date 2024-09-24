terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.68.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "efordocker" {
  ami           = "ami-00f07845aed8c0ee7"
  instance_type = "t2.micro"
  user_data     = <<-EOF
      #!/bin/bash
      # Update the system and install Docker
      yum update -y
      yum install docker -y
      
      # Start Docker service
      systemctl start docker
      systemctl enable docker
      
      # Add ec2-user to the Docker group to run Docker commands without sudo
      usermod -aG docker ec2-user
      
      # Reboot the instance to ensure Docker group membership is applied
      reboot
  EOF
  tags = {
    name = "DockerEC2"
  }
}