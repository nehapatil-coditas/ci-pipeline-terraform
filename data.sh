#!/bin/bash
sudo su
yum update -y
yum install docker -y
service docker start
systemctl enable docker
usermod -a -G docker ec2-user
docker pull nehapatil108/api-flask-app:latest
docker run -d -p 80:80 --restart always --log-driver=awslogs --log-opt awslogs-region=us-east-1 --log-opt awslogs-group=myapp-log-group --log-opt awslogs-create-group=true nehapatil108/api-flask-app:latest