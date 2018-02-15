#!/bin/sh

echo 'Download and install the public signing key:'
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

echo 'Copying files into /etc/yum.repos.d/[elasticsearch.repo|kibana.repo|logstash.repo]'
sudo cp elasticsearch.repo /etc/yum.repos.d/
sudo cp kibana.repo /etc/yum.repos.d/
sudo cp logstash.repo /etc/yum.repos.d/

echo 'yum install components'
sudo yum -y install elasticsearch
sudo yum -y install kibana
sudo yum -y install logstash

echo 'Create unix services'
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl enable logstash.service

sudo /sbin/chkconfig --add elasticsearch
sudo /sbin/chkconfig --add kibana
sudo /sbin/chkconfig --add logstash

sudo /sbin/chkconfig elasticsearch on
sudo /sbin/chkconfig kibana on
sudo /sbin/chkconfig logstash on

curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.2.1-x86_64.rpm
sudo rpm -vi metricbeat-6.2.1-x86_64.rpm
