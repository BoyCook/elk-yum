# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 4096]
  end

  config.vm.network "private_network", ip: "192.168.33.10", virtualbox__intnet: true
  config.vm.network "forwarded_port", guest: 9200, host: 9200
  config.vm.network "forwarded_port", guest: 5601, host: 5601
  config.vm.provision "file", source: "rabbitmq-erlang.repo", destination: "/tmp/rabbitmq-erlang.repo"
  config.vm.provision "file", source: "mongodb-org-3.6.repo", destination: "/tmp/mongodb-org-3.6.repo"
  config.vm.provision "file", source: "elastic.repo", destination: "/tmp/elastic.repo"
  config.vm.provision "file", source: "auditbeat.yml", destination: "/tmp/auditbeat.yml"
  config.vm.provision "file", source: "filebeat.yml", destination: "/tmp/filebeat.yml"
  config.vm.provision "file", source: "heartbeat.yml", destination: "/tmp/heartbeat.yml"
  config.vm.provision "file", source: "metricbeat.yml", destination: "/tmp/metricbeat.yml"
  config.vm.provision "file", source: "packetbeat.yml", destination: "/tmp/packetbeat.yml"

  config.vm.provision "shell", inline: <<-SHELL
    sudo yum install net-tools
    BASE_URL=http://download.oracle.com/otn-pub/java/jdk
    JAVA_URL="$BASE_URL/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
    curl -L -C - -b "oraclelicense=accept-securebackup-cookie" -O "${JAVA_URL}"
    sudo yum -y localinstall jdk-8u131-linux-x64.rpm

    sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
    sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
    sudo rpm --import https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc

    sudo mv /tmp/*.repo /etc/yum.repos.d/
    curl -O -L https://dl.bintray.com/rabbitmq/all/rabbitmq-server/3.7.3/rabbitmq-server-3.7.3-1.el7.noarch.rpm
    echo 'yum install components'
    sudo yum -y install elasticsearch kibana logstash metricbeat filebeat packetbeat heartbeat-elastic auditbeat
    sudo yum -y install erlang mongodb-org rabbitmq-server-3.7.3-1.el7.noarch.rpm

    # echo 'network.host: 0.0.0.0' | sudo tee -a /etc/elasticsearch/elasticsearch.yml
    # echo 'http.host: 0.0.0.0' | sudo tee -a /etc/logstash/logstash.yml
    # echo 'server.host: 0.0.0.0' | sudo tee -a /etc/kibana/kibana.yml

    sudo cp /tmp/auditbeat.yml /etc/auditbeat
    sudo cp /tmp/filebeat.yml /etc/filebeat
    sudo cp /tmp/heartbeat.yml /etc/heartbeat
    sudo cp /tmp/metricbeat.yml /etc/metricbeat
    sudo cp /tmp/packetbeat.yml /etc/packetbeat

    echo 'Create unix services'
    sudo /bin/systemctl enable elasticsearch
    sudo /bin/systemctl enable kibana
    sudo /bin/systemctl enable logstash
    sudo /bin/systemctl enable metricbeat
    sudo /bin/systemctl enable filebeat
    sudo /bin/systemctl enable packetbeat
    sudo /bin/systemctl enable heartbeat-elastic
    sudo /bin/systemctl enable auditbeat

    sudo /sbin/chkconfig kibana on
    sudo /sbin/chkconfig elasticsearch on
    sudo /sbin/chkconfig logstash on
    sudo /sbin/chkconfig metricbeat on
    sudo /sbin/chkconfig filebeat on
    sudo /sbin/chkconfig packetbeat on
    sudo /sbin/chkconfig heartbeat-elastic on
    sudo /sbin/chkconfig auditbeat on
    sudo /sbin/chkconfig rabbitmq-server on
    sudo /sbin/chkconfig mongod on

    sudo service kibana start
    sudo service elasticsearch start
    sudo service logstash start
    sudo service metricbeat start
    sudo service filebeat start
    sudo service packetbeat start
    sudo service heartbeat-elastic start
    sudo service auditbeat start
    sudo service rabbitmq-server start
    sudo service mongod start

    sudo metricbeat modules enable mongodb rabbitmq kibana logstash

    cd /usr/share/elasticsearch
    sudo bin/elasticsearch-plugin install x-pack
    sudo bin/x-pack/setup-passwords interactive

    cd /usr/share/kibana
    sudo bin/kibana-plugin install x-pack

    cd /usr/share/logstash
    sudo bin/logstash-plugin install x-pack

    # sudo metricbeat setup
    # sudo filebeat setup
    # sudo packetbeat setup
    # sudo heartbeat setup
    # sudo auditbeat setup
  SHELL
end
