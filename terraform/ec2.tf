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

locals {
  azs_count = 2
  azs_names = data.aws_availability_zones.available.names
}

resource "aws_subnet" "public" {
  count                   = local.azs_count
  vpc_id                  = aws_vpc.main.id
  availability_zone       = local.azs_names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 1)
  map_public_ip_on_launch = true
  tags                    = { Name = "public-${local.azs_names[count.index]}" }
}