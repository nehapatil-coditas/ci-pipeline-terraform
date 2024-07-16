# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name             = "web-asg"
  min_size         = 1
  desired_capacity = 1
  max_size         = 4

  health_check_type = "ELB"
  target_group_arns = ["${aws_lb_target_group.web_tg.arn}"]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  enabled_metrics = [
    "GroupInServiceInstances",
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier = [
    "${aws_subnet.demosubnet.id}",
    "${aws_subnet.demosubnet1.id}"
  ]
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}