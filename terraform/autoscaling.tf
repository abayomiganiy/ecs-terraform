resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  vpc_zone_identifier  = data.aws_subnets.public.ids
  launch_configuration = aws_launch_configuration.ecs_config.name
  health_check_type    = "EC2"
  target_group_arns    = [aws_lb_target_group.app_tg.arn]
  tag {
    key                 = "Name"
    value               = "${var.app_name}-ec2"
    propagate_at_launch = true
  }
}
