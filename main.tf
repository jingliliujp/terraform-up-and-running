provider "aws" {
    region = "ap-northeast-1"
}

resource "aws_instance" "example" {
    ami = "ami-07c589821f2b353aa"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.example.id]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World!" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    user_data_replace_on_change = true

    tags = {
        Name = "terraform-example"
    }
}

resource "aws_security_group" "example" {
    name = "terraform-example"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}