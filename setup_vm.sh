#!/bin/sh

# vagrant init vagrant-centos-7.2
vagrant init centos/7
yum makecache fast
sudo yum install git
git clone https://gist.github.com/dccbd2cd1e5dc9b61df0fe32a9d562bf.git setupjava
cd setupjava
./insall_java.sh
git clone https://github.com/BoyCook/elk-yum.git
