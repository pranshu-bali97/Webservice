provider "aws" {
  region = "ap-south-1"  # Replace with your desired region
}

resource "aws_instance" "example" {
  ami           = "ami-0d13e3e640877b0b9"  # Replace with the desired AMI ID
  instance_type = "t2.micro"               # Replace with the desired instance type
  key_name      = "1"          
  subnet_id = aws_subnet.subnet1.id            # Replace with your SSH key pair name
  associate_public_ip_address = false      # Set to false to assign a private IP address
  iam_instance_profile   = aws_iam_instance_profile.example_instance_profile2.name
  vpc_security_group_ids = [aws_security_group.sg.id]  # Replace with the desired security group ID
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    service nginx start
  EOF

  tags = {
    Name = "test321"
  }
}

resource "aws_ebs_encryption_by_default" "example" {
  enabled = true
}


resource "aws_iam_role" "example2_role" {
  name = "example2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "example_instance_profile2" {
  name = "example-instance2"
  role = aws_iam_role.example2_role.name
}



resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.example2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


