resource "aws_key_pair" "ecs_key" {
  key_name   = "${var.app_name}-key"
  public_key = file("~/.ssh/id_rsa.pub")
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

data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}
