resource "aws_launch_template" "web" {
  name_prefix   = "lt-"
  image_id      = "ami-01fccab91b456acc2"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  network_interfaces {
    subnet_id                   = aws_subnet.demosubnet.id
    security_groups             = [aws_security_group.demosg1.id]
    associate_public_ip_address = true
  }
  user_data = base64encode(file("data.sh"))
  monitoring {
    enabled = true
  }
  iam_instance_profile {
    name = "ec2-cloudwatch-access"
  }
  lifecycle {
    create_before_destroy = true
  }
}