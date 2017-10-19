# NAT module output

output "aws_vpc_main_id" {
  value = "${aws_vpc.main.id}"
}

# for server
output "aws_subnet_private_id_1" {
  value = "${aws_subnet.main-private-1.id}"
}

# for agent
output "aws_subnet_public_id_1" {
  value = "${aws_subnet.main-public-1.id}"
}
