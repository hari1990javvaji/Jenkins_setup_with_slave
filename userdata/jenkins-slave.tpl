#!/bin/bash
sudo yum install -y java-11-openjdk-devel
sudo yum -y install git
sudo yum -y install docker
sudo usermod -aG docker ec2-user
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo service docker start
sudo service docker enable
sudo sleep 120
sudo curl http://${jenkins_url}:8080/jnlpJars/jenkins-cli.jar -o /tmp/jenkins-cli.jar
sudo java -jar /tmp/jenkins-cli.jar -s http://${jenkins_url}:8080 create-job tooploox-sentry < /tmp/job.xml
sudo sh /tmp/join-master.sh ${jenkins_url} general-build