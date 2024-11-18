#################################
####  database subnet group #####
#################################
resource "aws_db_subnet_group" "database-subnet-group" {
  name        = "database subnets"
  subnet_ids  = [var.private_3, var.private_4]
  description = "Subnet group for database instance"

  tags = {
    Name = "Database Subnets"
  }
}

###################################
## SG  Database Tier         ###
###################################

resource "aws_security_group" "database-security-group" {
  name        = "Database server Security Group"
  description = "Enable MYSQL access on port 3306"
  vpc_id      = var.vpc_main

  ingress {
    description     = "MYSQL access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${var.app_sg}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database Security group"
  }
}
#################################
####  database instance      #####
#################################
resource "aws_db_instance" "database-instance" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "mydatabase"
  username               = "root"
  password               = "12345678"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  availability_zone      = "us-east-1a"
  db_subnet_group_name   = aws_db_subnet_group.database-subnet-group.name
  vpc_security_group_ids = [aws_security_group.database-security-group.id]
}
