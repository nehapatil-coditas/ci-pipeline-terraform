# Load Balancer
resource "aws_lb" "web_elb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.demosg1.id}"]
  subnets = [
    "${aws_subnet.demosubnet.id}",
    "${aws_subnet.demosubnet1.id}"
  ]
  enable_cross_zone_load_balancing = true
}

#Target group
resource "aws_lb_target_group" "web_tg" {
  name     = "alb-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demovpc.id
}

#Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}