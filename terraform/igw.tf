# Creating internet gateway
resource "aws_internet_gateway" "demogateway" {
  vpc_id = aws_vpc.demovpc.id
}