# Slave "general builds"
resource "aws_instance" "jenkins_node" {
  ami             = data.aws_ami.redhat.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_traffic.name]
  key_name        = "jenkins"
  user_data       = data.template_file.userdata_jenkins_worker_linux.rendered
  tags = {
    Name = "Jenkins-node"
  }
  depends_on = [aws_instance.jenkins, null_resource.os_update, null_resource.install_jenkins]

  root_block_device {
    volume_type = "gp2"
    volume_size = 10
  }
  tags {
    Name = "node general builds"
    Tool = "Terraform"
  }
}

data "local_file" "jenkins_worker_pem" {
  filename = file(var.public_key)
}

data "template_file" "userdata_jenkins_worker_linux" {
  template = file("userdata/jenkins-node.tpl")
  vars {
    jenkins_url      = "jenkins.robofarming.link"
    server_ip        = aws_instance.jenkins_server.private_ip
    jenkins_username = "admin"
    jenkins_password = "password"
    worker_pem       = data.local_file.jenkins_worker_pem.content
  }
}