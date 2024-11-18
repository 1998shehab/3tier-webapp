###################################
## SG app alb Tier         ###
###################################
resource "aws_security_group" "app-alb-security-group" {
  name        = "app alb Security Group"
  description = "Enable http/https access on port 80/443 via ALB and ssh via ssh sg"
  vpc_id      = var.vpc_main

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${var.web_sg}"]
  }

#  ingress {
#    description     = "ssh access"
#    from_port       = 22
#    to_port         = 22
#    protocol        = "tcp"
#    security_groups = ["${aws_security_group.bastion-security-group.id}"]
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app loadbalncer Security group"
  }
}

###################################
## SG app Tier         ###
###################################
resource "aws_security_group" "app-security-group" {
  name        = "app Security Group"
  description = "Enable http/https access on port 80/443 via ALB and ssh via ssh sg"
  vpc_id      = var.vpc_main

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-alb-security-group.id}"]
  }

#  ingress {
#    description     = "ssh access"
 #   from_port       = 22
  #  to_port         = 22
 #   protocol        = "tcp"
 #   security_groups = ["${aws_security_group.bastion-security-group.id}"]
  #}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app Security group"
  }
}

#                         You call it from main so . is inside the module
# user_data = base64encode(templatefile("./user-data/user-data-presentation-tier.sh", {
#     application_load_balancer = var.alb_App_dns_name,
#     region                    = var.region
#   }))

  #  user_data = base64encode(templatefile("./user-data/user-data-application-tier.sh", {
  #   rds_hostname  = var.rds_address,
  #   rds_username  = var.rds_db_admin,
  #   rds_password  = var.rds_db_password,
  #   rds_port      = 3306,
  #   rds_db_name   = var.db_name,
  #   region        = var.region
  # }))

# the same shape of the variables in the template
# terraform doesn't clear the cache but aws cli does
# Try to do the following commands before creating another instance with a new ami
# in order to clear the old ami from cache
# sudo rm -rf /var/lib/cloud/*
# sudo cloud-init clean

resource "aws_launch_template" "auto-scaling-group-private" {
  name_prefix   = "auto-scaling-group-private"
  image_id      = var.app_ami
  instance_type = "t2.micro"
  key_name      = var.key_pair

  network_interfaces {
    subnet_id       = var.private_1
    security_groups = [aws_security_group.app-security-group.id]
  }
}

resource "aws_autoscaling_group" "asg-app" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2

  launch_template {
    id      = aws_launch_template.auto-scaling-group-private.id
    version = "$Latest"
  }
}


############################
##   application app load balancer ##
#############################
resource "aws_lb" "application-load-balancer" {
  name                       = "app-internal-load-balancer"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.app-alb-security-group.id]
  subnets                    = [var.private_1, var.private_2]
  enable_deletion_protection = false

  tags = {
    Name = "App load balancer"
  }
}

resource "aws_lb_target_group" "app_alb_target_group" {
  name     = "apptg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_main
}

# resource "aws_lb_target_group_attachment" "app-attachment" {
#   target_group_arn = aws_lb_target_group.app_alb_target_group.arn
#   target_id        = aws_autoscaling_group.asg-app.id
#   port             = 80
# }
resource "aws_autoscaling_attachment" "app" {
  autoscaling_group_name = aws_autoscaling_group.asg-app.id
  lb_target_group_arn    = aws_lb_target_group.app_alb_target_group.arn
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application-load-balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_alb_target_group.arn
  }
}


