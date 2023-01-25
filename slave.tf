resource "aws_instance" "jenkins_slave" {
  ami             = data.aws_ami.redhat.id
  instance_type   = "t2.micro"
  key_name        = "jenkins"
  security_groups = [aws_security_group.web_traffic.name]
  user_data       = data.template_file.user_data_slave.rendered
  depends_on      = [aws_instance.jenkins]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = false
  }
  tags {
    Name = "Slave general builds"
    Tool = "Terraform"
  }
}

data "template_file" "user_data_slave" {
  template = file("${path.module}/userdata/jenkins-slave.tpl")
  vars {
    jenkins_url = var.domainName
  }
}