NUM_WORKER_NODES=2
IP_NW="10.0.0."
IP_START=10

Vagrant.configure("2") do |config|
    config.vm.provider "libvirt" do |libvirt|
        libvirt.management_network_address = '192.169.121.0/24'
    end
    config.vm.synced_folder "./", "/vagrant", type: "nfs"
    config.vm.provision "shell", inline: <<-SHELL
        apt-get update -y
        echo "$IP_NW$((IP_START))  master-node" >> /etc/hosts
        echo "$IP_NW$((IP_START+1))  worker-node01" >> /etc/hosts
        echo "$IP_NW$((IP_START+2))  worker-node02" >> /etc/hosts
    SHELL
    config.vm.box = "bento/ubuntu-20.04"
    config.vm.box_check_update = true

    config.vm.define "master" do |master|
      master.vm.hostname = "master-node"
      master.vm.network "private_network", ip: IP_NW + "#{IP_START}"
      master.vm.provider "libvirt" do |vb|
          vb.memory = 4048
          vb.cpus = 2
          #vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
      master.vm.provision "linuxmaster", type: "shell", path: "scripts/linuxprep.sh"
      master.vm.provision "commonmaster", type: "shell", path: "scripts/common.sh"
      master.vm.provision "master", type: "shell", path: "scripts/master.sh"
    end

    (1..NUM_WORKER_NODES).each do |i|
      config.vm.define "node0#{i}" do |node|
        node.vm.hostname = "worker-node0#{i}"
        node.vm.network "private_network", ip: IP_NW + "#{IP_START + i}"
        node.vm.provider "libvirt" do |vb|
            vb.memory = 2048
            vb.cpus = 1
            #vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        end
        node.vm.provision "linuxnode", type: "shell", path: "scripts/linuxprep.sh"
        node.vm.provision "commonnode", type: "shell", path: "scripts/common.sh"
        node.vm.provision "node", after: "master", type: "shell", path: "scripts/node.sh"
      end
    end
  end
