variable "ak" {
  type = string
}
variable "pk" {
  type = string
}


provider "aws" {
  region     = "ap-south-1"
  access_key = var.ak
  secret_key = var.pk

}
resource "aws_security_group" "ssg" {
  tags = {
    Name = "security group"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server" {
  ami             = "ami-0f2ce9ce760bd7133"
  instance_type   = "t2.micro"
  key_name        = "n2025"
  count           = "2"
  security_groups = [aws_security_group.ssg.name]
  tags = {
    Name = "worker_server-${count.index + 1}"
  }
  user_data = file("userdata.sh")
}

output "private_ip1" {
  value = aws_instance.server[0].private_ip
}

output "private_ip2" {
  value = aws_instance.server[1].private_ip
}