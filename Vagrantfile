Vagrant.configure("2") do |config|

  # Control plane
  (1..3).each do |i|
    hostname = "k8sctl#{i}"
    config.vm.define hostname do |node|
      node.vm.box = "ubuntu/xenial64"
      node.vm.hostname = hostname
      node.vm.network "private_network", ip: "10.32.2.#{10+i}"

      config.vm.provider "virtualbox" do |v|
        v.name = "K8s Control #{i}"
      end

    end
  end

  # Workers
  (1..3).each do |i|
    hostname = "k8swrk#{i}"
    config.vm.define hostname do |node|
      node.vm.box = "ubuntu/xenial64"
      node.vm.hostname = hostname
      node.vm.network "private_network", ip: "10.32.2.#{30+i}"

      config.vm.provider "virtualbox" do |v|
        v.name = "K8s Worker #{i}"
      end
    end
  end

  # Load balancer
  (1..1).each do |i| # No loop needed, but do it anyways
    hostname = "haprx#{i}"
    config.vm.define hostname do |node|
      node.vm.box = "ubuntu/xenial64"
      node.vm.hostname = hostname
      node.vm.network "private_network", ip: "10.32.2.#{20+i}"

      config.vm.provider "virtualbox" do |v|
        v.name = "K8s Cluster Proxy #{i}"
      end
    end
  end
end
