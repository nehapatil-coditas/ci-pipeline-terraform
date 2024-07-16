resource "aws_vpc" "demovpc" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = "Demo VPC"
  }
}