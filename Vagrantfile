Vagrant.configure("2") do |config|

  # Control plane
  (1..3).each do |i|
    hostname = "k8sctl#{i}"
    config.vm.define hostname do |node|
      node.vm.box = "ubuntu/xenial64"
      node.vm.hostname = hostname
      node.vm.network "private_network", ip: "10.32.2.#{10+i}"

      node.vm.provider "virtualbox" do |v|
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
        node.vm.provision "file", source: "./tmp/#{f}", destination: "$HOME/#{f}"
      end

      {
        "encryption-config.yaml" => "encryption-config.yaml",
        "#{hostname}-etcd.service" => "etcd.service",
        "#{hostname}-kube-apiserver.service" => "kube-apiserver.service",
        "kube-controller-manager.service" => "kube-controller-manager.service",
        "kube-scheduler.service" => "kube-scheduler.service",
        "kube-apiserver-to-kubelet-role.yaml" => "kube-apiserver-to-kubelet-role.yaml",
        "kube-apiserver-to-kubelet-binding.yaml" => "kube-apiserver-to-kubelet-binding.yaml",
      }.each do |src, dst|
        node.vm.provision "file", source: "./provision/#{src}", destination: "$HOME/#{dst}"
      end

      [
        "hosts.sh",
        "etcd.sh",
        "master.sh",
      ].each do |f|
        node.vm.provision "shell", path: "./provision/#{f}"
      end

      if i == 3 then # Ugh! There has to be a better way!
        node.vm.provision "shell", path: "./provision/rbac.sh"
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

      node.vm.provider "virtualbox" do |v|
        v.name = "K8s Worker #{i}"
      end

      node.vm.provision "shell", path: "provision/hosts.sh"

      [
        "ca.pem",
        "k8swrk#{i}-key.pem",
        "k8swrk#{i}.pem",
        "k8swrk#{i}.kubeconfig",
        "kube-proxy.kubeconfig",
        "cni-plugins.tgz",
        "containerd.tar.gz",
        "runc",
        "crictl",
        "kubectl",
        "kube-proxy",
        "kubelet",
      ].each do |f|
        node.vm.provision "file", source: "./tmp/#{f}", destination: "$HOME/#{f}"
      end

      {
        "k8swrk#{i}-kubelet.service" => "kubelet.service",
        "kube-proxy.service" => "kube-proxy.service",
        "containerd.service" => "containerd.service",
        "crictl.yaml" => "crictl.yaml",
      }.each do |src, dst|
        node.vm.provision "file", source: "./provision/#{src}", destination: "$HOME/#{dst}"
      end

      node.vm.provision "shell", path: "provision/worker.sh", args: ["k8swrk#{i}"]

    end
  end

  # Load balancer
  (1..1).each do |i| # No loop needed, but do it anyways
    hostname = "haprx#{i}"
    config.vm.define hostname do |node|
      node.vm.box = "ubuntu/xenial64"
      node.vm.hostname = hostname
      node.vm.network "private_network", ip: "10.32.2.#{20+i}"

      node.vm.provider "virtualbox" do |v|
        v.name = "K8s Cluster Proxy #{i}"
      end

      node.vm.provision "shell", path: "provision/hosts.sh"

      node.vm.provision "file", source: "./provision/haproxy.cfg-addendum", destination: "$HOME/haproxy.cfg-addendum"
      node.vm.provision "shell", path: "provision/haproxy.sh"
    end
  end
end
