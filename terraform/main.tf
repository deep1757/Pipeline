provider "aws" {
  region = "us-west-2" # Replace with your desired region
}

resource "aws_instance" "example" {
  ami           = "ami-0e0f3d4588f992288" # Replace with your desired AMI
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo mkdir -p /var/www/html
              sudo cp ./app/index.html /var/www/html/
              sudo apt update && sudo apt install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              sudo systemctl status apache2
              EOF

  tags = {
    Name = "Terraform CICD"
  }

  security_groups = [aws_security_group.http_sg.name]
}

resource "aws_security_group" "http_sg" {
  name        = "http-sg"
  description = "Allow incoming HTTP and SSH traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic from all sources (for demonstration purposes)
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic from all sources (for demonstration purposes)
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
