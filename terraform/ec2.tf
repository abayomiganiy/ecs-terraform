resource "tls_private_key" "ecs_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ecs_key" {
  key_name   = "${var.app_name}-key"
  public_key = tls_private_key.ecs_key.public_key_openssh
}

resource "aws_launch_template" "ecs_template" {
  name_prefix   = "ecs-launch-template-"
  image_id      = data.aws_ami.ecs_ami.id
  instance_type = "t2.micro"

  key_name               = aws_key_pair.ecs_key.key_name
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-2"
  }
}