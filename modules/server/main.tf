# SERVER module main.tf

module "nat-mod" {
  source = "../nat"
}

resource "aws_security_group" "allow-ssh-and-puppet" {
  vpc_id = "${module.nat-mod.aws_vpc_main_id}"
  name = "allow-ssh-and-puppet"
  description = "security group that allows ssh and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 8140
      to_port = 8140
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-ssh-and-puppet"
  }
}

resource "aws_instance" "puppet-server" {
    ami = "${var.AMI}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    depends_on = ["aws_security_group.allow-ssh-and-puppet"]
    subnet_id = "${module.nat-mod.aws_subnet_private_id_1}"
    vpc_security_group_ids = ["${aws_security_group.allow-ssh-and-puppet.id}"]
    root_block_device {
      volume_size = "12"
      delete_on_termination = true
    }
    tags {
        Name = "PuppetServer"
      }
}

# Agent module main.tf


resource "aws_security_group" "allow-ssh" {
  vpc_id = "${module.nat-mod.aws_vpc_main_id}"
  name = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-ssh"
  }
}

resource "aws_instance" "puppet-agent" {
    ami = "${var.AMI}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    depends_on = ["aws_security_group.allow-ssh"]
    subnet_id = "${module.nat-mod.aws_subnet_public_id_1}"
    vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
    root_block_device {
      volume_size = "8"
      delete_on_termination = true
    }
    tags {
        Name = "PuppetAgent"
      }
}
