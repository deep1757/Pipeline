provider "aws" {
  region = "us-west-2" # Replace with your desired region
}

resource "aws_instance" "example" {
  ami           = "ami-04e35eeae7a7c5883" # Replace with your desired AMI
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform CICD"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "echo '<h1>Hello, this is your website!</h1>' | sudo tee /var/www/html/index.html"
    ]
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
}

output "website_url" {
  value = "http://${aws_instance.example.public_ip}:80"
}
