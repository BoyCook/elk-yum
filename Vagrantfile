# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos/7"

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 4096]
  end

  config.vm.network "private_network", ip: "192.168.33.10", virtualbox__intnet: true
  config.vm.network "forwarded_port", guest: 9200, host: 9200
  config.vm.network "forwarded_port", guest: 5601, host: 5601

  config.vm.provision "file", source: "elasticsearch.repo", destination: "/tmp/elasticsearch.repo"
  config.vm.provision "file", source: "kibana.repo", destination: "/tmp/kibana.repo"
  config.vm.provision "file", source: "logstash.repo", destination: "/tmp/logstash.repo"
  
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    sudo yum install net-tools
    BASE_URL=http://download.oracle.com/otn-pub/java/jdk
    JAVA_URL="$BASE_URL/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
    curl -L -C - -b "oraclelicense=accept-securebackup-cookie" -O "${JAVA_URL}"
    sudo yum -y localinstall jdk-8u131-linux-x64.rpm

    sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

    sudo mv /tmp/*.repo /etc/yum.repos.d/
    echo 'yum install components'
    sudo yum -y install elasticsearch kibana logstash

    echo 'network.host: "0.0.0.0"' | sudo tee -a /etc/elasticsearch/elasticsearch.yml
    echo 'http.host: "0.0.0.0"' | sudo tee -a /etc/logstash/logstash.yml
    echo 'server.host: "0.0.0.0"' | sudo tee -a /etc/kibana/kibana.yml

    echo 'Create unix services'
    sudo /bin/systemctl enable elasticsearch
    sudo /bin/systemctl enable kibana
    sudo /bin/systemctl enable logstash

    sudo systemctl start kibana
    sudo systemctl start elasticsearch
    sudo systemctl start logstash
  SHELL

end
