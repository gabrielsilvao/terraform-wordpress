resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  key_name               = "access-key"
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  subnet_id              = aws_subnet.production-pub.id
  user_data              = file("wordpress.sh")

  tags = {
    "Name" = "Wordpress"
  }

  depends_on = [
    aws_db_instance.wordpress
  ]
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  key_name               = "access-key"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = aws_subnet.production-pub.id

  tags = {
    "Name" = "bastion"
  }
}