#!/usr/bin/bash

# Install packages
yum -y update
yum install -y emacs-nox nano tree python3
yum install -y git

# Configure/install custom software
cd /home/ec2-user
git clone https://github.com/zacharylong/python-image-gallery-m6.git
chown -R ec2-user:ec2-user python-image-gallery-m6
su ec2-user -c "cd ~/python-image-gallery-m6 && pip3 install -r requirements.txt --user"

# Start/enable services
systemctl stop postfix
systemctl disable postfix

# copy config files to s3 bucket

BUCKET="edu.au.cc.m5-image-gallery-superunique-config"

cd /home/ec2-user/python-image-gallery-m6

aws s3 cp ec2-scripts/ec2-prod-1.1.sh s3://${BUCKET}
aws s3 cp ec2-scripts/ec2-prod-latest.sh s3://${BUCKET}
aws s3 sync nginx s3://${BUCKET}/nginx