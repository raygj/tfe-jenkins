provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_instance" "jenkins-demo" {
  count         = "${var.count}"
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"

  tags {
    Name  = "${var.name}-${count.index}"
    owner = "${var.owner}"
    TTL   = "${var.ttl}"
  }

  user_data = "${var.user_data}"
  key_name  = "${var.key_name}"
  subnet_id = "${var.subnet_id}"

  vpc_security_group_ids = "${var.security_group_id}"
}
