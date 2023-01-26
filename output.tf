output "jenkins-public-ip" {
  value = aws_instance.jenkins.public_ip
}

output "userdata" {
  value = data.template_file.userdata_jenkins_worker_linux.rendered
}