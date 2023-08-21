provider "aws" {
  region = "us-west-2" # Replace with your desired region
}

resource "aws_instance" "example" {
  ami           = "ami-0e0f3d4588f992288" # Replace with your desired AMI
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform CICD"
  }
}

resource "aws_security_group" "http_sg" {
  name        = "http-sg"
  description = "Allow incoming HTTP traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic from all sources (for demonstration purposes)
  }
}

resource "aws_security_group_rule" "instance_ingress" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Allowing traffic from all sources (for demonstration purposes)
  security_group_id = aws_instance.example.security_groups[0]
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
