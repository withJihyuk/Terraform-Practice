provider "aws" {
    region = "ap-northeast-2"
}

resource "aws_instance" "backend_server" {
    ami = "ami-062cf18d655c0b1e8" // 우분투
    instance_type = "t2.micro" // 추후 바꿔줄 수 있다.
    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.test_rule.id]
    user_data = <<-EOF
		#!/bin/bash
		echo "Hello, World" > index.html
		nohup busybox httpd -f -p 8080 &
		EOF
    tags = {
        Name = "backend_server"
    }
}

