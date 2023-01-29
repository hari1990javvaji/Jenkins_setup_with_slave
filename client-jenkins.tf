/*# Slave "general builds"

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
}

/* data "local_file" "jenkins_worker_pem" {
  filename = file(var.private_key)
} */

/*data "aws_ssm_parameter" "private_key" {
  name       = "${module.key_pair.key_pair_name}-private"
  depends_on = [resource.aws_ssm_parameter.private_key]
}


data "template_file" "userdata_jenkins_worker_linux" {
  template = file("userdata/jenkins-node.sh")

  vars = {
    jenkins_url      = "jenkins.robofarming.link"
    jenkins_username = "admin"
    jenkins_password = "password"
    device_name      = "eth0"
    worker_pem       = data.aws_ssm_parameter.private_key.value
  }
}

# null resource 
resource "null_resource" "install_jenkins_slave" {
  depends_on = [aws_instance.jenkins_node, data.template_file.userdata_jenkins_worker_linux]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key)
    host        = aws_instance.jenkins_node.public_ip
    timeout     = "20s"
  }

  provisioner "file" {
    connection {
      host        = aws_instance.jenkins_node.public_ip
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key)
      timeout     = "50s"
    }

    source      = "~/.ssh"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "sudo mv /tmp/.ssh /var/lib/jenkins/ &> /dev/null",
      "sudo chown -R ec2-user:ec2-user /var/lib/jenkins/",
      "sudo chmod 0600 /var/lib/jenkins/.ssh/id*",
    ]
  }
}*/