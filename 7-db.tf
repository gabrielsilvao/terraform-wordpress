resource "aws_db_subnet_group" "wordpress" {
  name = "wordpress"
  subnet_ids = [ "aws_subnet.production-priv", "aws_subnet.production-priv2" ]

  depends_on = [
    aws_vpc.production
  ]
}

resource "aws_security_group" "rds" {
  name = "rds wordpress"
  description = "security group rds"
  vpc_id = aws_vpc.production.id

  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      security_groups = [ aws_security_group.wordpress_sg.vpc_id ]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "rds security group"
  }
}

resource "aws_db_instance" "wordpress" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  name = "wordpress"
  username = "admin"
  password = "Seletiva#39"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  vpc_security_group_ids = ["aws_db_subnet_group.wordpress.id"]
}