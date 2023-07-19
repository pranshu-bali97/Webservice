resource "aws_elb" "example_elb" {
  name               = "example-elb"
  subnets            = [aws_subnet.subnet2.id]                   # Replace with the desired subnet IDs
  security_groups    = [aws_security_group.sg.id]               # Replace with the desired security group ID
  idle_timeout       = 400
  cross_zone_load_balancing = true

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  tags = {
    Name = "example-elb"
  }
}

resource "aws_lb_target_group" "example_target_group" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-00da2c6b7796c7423"                      # Replace with the ID of your VPC

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "example_attachment" {
  target_group_arn = aws_lb_target_group.example_target_group.arn
  target_id        = aws_instance.example.id       # Replace with the ID of your instance
  port             = 80
}


