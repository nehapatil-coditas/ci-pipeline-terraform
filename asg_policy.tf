# Autoscaling policy "Target Tracking policy" to spin the next instance when CPU utiliztion reaches 2%
resource "aws_autoscaling_policy" "web_policy_up" {
  name                      = "web_policy_up"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 200
  autoscaling_group_name    = aws_autoscaling_group.web.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 2.0
  }
}

# Adding cloud watch metric alarm when 4th instance spins up
resource "aws_cloudwatch_metric_alarm" "fourth_instance_alarm_up" {
  alarm_name          = "fourth_instance_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = "120"
  statistic           = "Sum"
  threshold           = 4
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  }
  alarm_description = "This metric monitors when the fourth EC2 instance starts running"
  alarm_actions     = [aws_sns_topic.instance_updates.arn]
}

