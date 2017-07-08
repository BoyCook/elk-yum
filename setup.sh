#!/bin/sh

echo 'Download and install the public signing key:'
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

echo 'Copying files into /etc/yum.repos.d/[elasticsearch.repo|kibana.repo|logstash.repo]'
cp elasticsearch.repo /etc/yum.repos.d/
cp kibana.repo /etc/yum.repos.d/
cp logstash.repo /etc/yum.repos.d/

sudo yum install elasticsearch
sudo yum install kibana
sudo yum install logstash
