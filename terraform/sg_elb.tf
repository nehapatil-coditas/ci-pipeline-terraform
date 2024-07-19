resource "aws_security_group" "demosg1" {
  name        = "Demo Security Group"
  description = "Demo Module"
  vpc_id      = aws_vpc.demovpc.id

  ingress {
    description = "Allow SSH traffic from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #tfsec:ignore:aws-vpc-no-public-ingress-sgr
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    #tfsec:ignore:aws-vpc-no-public-ingress-sgr
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Allow HTTPS traffic from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    #tfsec:ignore:aws-vpc-no-public-ingress-sgr
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    description = "All outgoing traffic allowded"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #tfsec:ignore:aws-vpc-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"] 
  }
}
