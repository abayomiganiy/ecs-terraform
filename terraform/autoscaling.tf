resource "aws_autoscaling_group" "ecs_asg" {
  name_prefix      = "ecs-asg-"
  max_size         = 4
  min_size         = 1
  desired_capacity = 2
  vpc_zone_identifier = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
  health_check_type = "EC2"
  target_group_arns = [aws_lb_target_group.app_tg.arn]
  launch_template {
    id      = aws_launch_template.ecs_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ECS Instance"
    propagate_at_launch = true
  }
}
