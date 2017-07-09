#!/bin/sh

echo 'Download and install the public signing key:'
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

echo 'Copying files into /etc/yum.repos.d/[elasticsearch.repo|kibana.repo|logstash.repo]'
cp elasticsearch.repo /etc/yum.repos.d/
cp kibana.repo /etc/yum.repos.d/
cp logstash.repo /etc/yum.repos.d/

echo 'yum install components'
sudo yum install elasticsearch
sudo yum install kibana
sudo yum install logstash

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
