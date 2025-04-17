resource "tls_private_key" "ecs_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ecs_key" {
  key_name   = "${var.app_name}-key"
  public_key = tls_private_key.ecs_key.public_key_openssh
}

resource "aws_launch_configuration" "ecs_config" {
  name_prefix   = "${var.app_name}-lc-"
  image_id      = data.aws_ami.ecs.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ecs_key.key_name
  security_groups = [aws_security_group.ecs_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
              EOF

  lifecycle {
    create_before_destroy = true
  }
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
