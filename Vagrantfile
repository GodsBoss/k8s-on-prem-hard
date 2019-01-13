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

      [
        "ca.pem", "ca-key.pem",
        "kubernetes-key.pem",
        "kubernetes.pem",
        "etcd",
        "etcdctl",
        "kube-apiserver",
        "kube-controller-manager",
        "kube-scheduler",
        "kubectl",
      ].each do |f|
        config.vm.provision "file", source: "./tmp/#{f}", destination: "$HOME/#{f}"
      end

      {
        "encryption-config.yaml" => "encryption-config.yaml",
        "#{hostname}-etcd.service" => "etcd.service",
      }.each do |src, dst|
        config.vm.provision "file", source: "./provision/#{src}", destination: "$HOME/#{dst}"
      end

      [
        "hosts.sh",
        "etcd.sh",
      ].each do |f|
        config.vm.provision "shell", path: "./provision/#{f}"
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

      config.vm.provision "shell", path: "provision/hosts.sh"

      [
        "ca.pem",
        "k8swrk#{i}-key.pem",
        "k8swrk#{i}.pem",
        "k8swrk#{i}.kubeconfig",
        "kube-proxy.kubeconfig",
      ].each do |f|
        config.vm.provision "file", source: "./tmp/#{f}", destination: "$HOME/#{f}"
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

      config.vm.provision "shell", path: "provision/hosts.sh"

      config.vm.provision "file", source: "./provision/haproxy.cfg-addendum", destination: "$HOME/haproxy.cfg-addendum"
      config.vm.provision "shell", path: "provision/haproxy.sh"
    end
  end
end
