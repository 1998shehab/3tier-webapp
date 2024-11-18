###################################
## SG web Load Balancer ###
###################################
resource "aws_security_group" "web-alb-security-group" {
  name        = "ALB Security Group"
  description = "Enable http access on port 80"
  vpc_id      = var.vpc_main

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web ALB Security group"
  }
}

###################################
## SG Presentation Tier         ###
###################################
resource "aws_security_group" "webserver-security-group" {
  name        = "Web server Security Group"
  description = "Enable http access on port 80 via ALB and ssh "
  vpc_id      = var.vpc_main

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web-alb-security-group.id}"]
  }

  # ingress {
  #   description     = "ssh access"
  #   from_port       = 22
  #   to_port         = 22
  #   protocol        = "tcp"
  #   security_groups = ["${aws_security_group.bastion-security-group.id}"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web server Security group"
  }
}

##################################
#### ASG for Presentation Tier ###
##################################

resource "aws_launch_template" "auto-scaling-group" {
  name_prefix   = "auto-scaling-group"
  image_id      = var.web_ami
  instance_type = "t2.micro"
  key_name      = var.key_pair
  network_interfaces {
    subnet_id       = var.public_1
    security_groups = [aws_security_group.webserver-security-group.id]
    associate_public_ip_address = false###################################
  }
}

resource "aws_autoscaling_group" "asg-web" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2

  launch_template {
    id      = aws_launch_template.auto-scaling-group.id
    version = "$Latest"
  }
}

############################
##   Web load balancer ##
#############################
resource "aws_lb" "web-load-balancer" {
  name                       = "web-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.web-alb-security-group.id]
  subnets                    = [var.public_1, var.public_2]
  enable_deletion_protection = false

  tags = {
    Name = "web load balancer"
  }
}

resource "aws_lb_target_group" "web_alb_target_group" {
  name     = "webbalancertg"#####web######################
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_main
}

# resource "aws_lb_target_group_attachment" "web-attachment" {
#   target_group_arn = aws_lb_target_group.web_alb_target_group.arn
#   target_id        = aws_autoscaling_group.asg-web.id
#   port             = 80
# }
resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.asg-web.id
  lb_target_group_arn    = aws_lb_target_group.web_alb_target_group.arn
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.web-load-balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_alb_target_group.arn
  }
}


