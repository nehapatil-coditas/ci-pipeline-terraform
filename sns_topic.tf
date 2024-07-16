resource "aws_sns_topic" "instance_updates" {
  name = "instance-updates-topic"
}

resource "aws_sns_topic_subscription" "instance_updates_sqs_target" {
  topic_arn = aws_sns_topic.instance_updates.arn
  protocol  = "email"
  endpoint  = "neha.patil@coditas.com"
}