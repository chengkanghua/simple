#!/bin/bash
: ' 
description:  k8s1.24 一键安装脚本
author:       chengkanghua
email：       chengkanghua@foxmail.com
date：        2023-2-12
'
set -xu


#--------------------------------------
#批量分发公钥
dispense(){
	#配置yum源
	rm -rf /etc/yum.repos.d/*
	curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
	curl -o /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	yum install -y sshpass
	#sshpass 简单使用说明
	# sshpass -p '1' ssh root@10.211.55.37 'df -h'
	# export SSHPASS='1' #密码加全局变量
	# sshpass -e ssh root@10.211.55.37 'df -h'
	#关闭ssh连接询问
	sed -i '/StrictHostKeyChecking/aStrictHostKeyChecking no' /etc/ssh/ssh_config

	#非交互创建密钥对
	[ -f ~/.ssh/id_rsa ] || ssh-keygen -t RSA -N '' -f ~/.ssh/id_rsa
	#分交互分发公钥
	sshpass -p1 ssh-copy-id -f -i ~/.ssh/id_rsa.pub "-o StrictHostKeyChecking=no" 10.211.55.37

	#批量分发
	# for ip in 7 61
	# do
	#   sshpass -p123456 ssh-copy-id -f -i ~/.ssh/id_rsa.pub "-o StrictHostKeyChecking=no" 172.16.1.$ip
	# done
}


#------------------------------------------
#配置host
sting_host(){
#设置host解析
hostnamectl set-hostname k8s-master #设置master节点的hostname
hostnamectl set-hostname k8s-slave1 #设置slave1节点的hostname
hostnamectl set-hostname k8s-slave2 #设置slave2节点的hostname

cat >>/etc/hosts<<EOF
10.211.55.36 k8s-master
10.211.55.37 k8s-slave1
10.211.55.39 k8s-slave2
EOF
}
#-------------------------------------
#调整系统配置
init_sys(){
iptables -P FORWARD ACCEPT

swapoff -a
sed -ri '/ swap / s/(.*)/#\1/g' /etc/fstab

sed -ri 's#(SELINUX=).*#\1disabled#' /etc/selinux/config
setenforce 0
systemctl disable firewalld && systemctl stop firewalld

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward=1
vm.max_map_count=262144
EOF
modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf

#配置yum源
rm -rf /etc/yum.repos.d/*
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
        http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
yum clean all && yum makecache
}


#---------------------------------------
#所有节点安装docker
inst_docker(){
yum install docker-ce-20.10.18 -y

cat > /etc/docker/daemon.json<<EOF
{                         
  "registry-mirrors" : [
    "https://8xpk5wnt.mirror.aliyuncs.com"
  ]
}
EOF

systemctl enable docker && systemctl start docker
}


#-------------------------------------
#初始化集群 所有节点
init_cluster(){
$ yum install -y kubelet-1.24.4 kubeadm-1.24.4 kubectl-1.24.4 --disableexcludes=kubernetes
$ systemctl enable kubelet 

#配置containerd
containerd config default > /etc/containerd/config.toml
sed -i "s#k8s.gcr.io/pause#registry.aliyuncs.com/google_containers/pause#g"       /etc/containerd/config.toml
sed -i "s#registry.k8s.io/pause#registry.aliyuncs.com/google_containers/pause#g"       /etc/containerd/config.toml

sed -i 's#SystemdCgroup = false#SystemdCgroup = true#g' /etc/containerd/config.toml

sed -i '145s#\"\"#\"/etc/containerd/certs.d\"#g' /etc/containerd/config.toml

mkdir -p /etc/containerd/certs.d/docker.io
cat >/etc/containerd/certs.d/docker.io/hosts.toml <<EOF
server = "https://docker.io"
[host."https://8xpk5wnt.mirror.aliyuncs.com"]
  capabilities = ["pull","resolve"]
[host."https://docker.mirrors.ustc.edu.cn"]
  capabilities = ["pull","resolve"]
[host."https://registry-1.docker.io"]
  capabilities = ["pull","resolve","push"]
EOF

systemctl restart containerd
}


#------------------------------------------
#mater节点初始化
int_master(){
kubeadm config print init-defaults > kubeadm.yaml

sed -ri 's#(advertiseAddress: ).*#\110.211.55.36#' kubeadm.yaml
sed -ri 's#(name: ).*#\1k8s-master#' kubeadm.yaml
sed -ri 's#(imageRepository: ).*#\1registry.aliyuncs.com/google_containers#' kubeadm.yaml
sed -ri 's#(kubernetesVersion: ).*#\11.24.4#' kubeadm.yaml
sed -i '/dnsDomain:/a\ \ podSubnet: 10.244.0.0/16' kubeadm.yaml

kubeadm config images list --config kubeadm.yaml
kubeadm config images pull --config kubeadm.yaml
kubeadm init --config kubeadm.yaml > kubeadm_init.log
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

#添加slave节点到集群中
join=`grep -E 'kubeadm join.*|sha256' kubeadm_init.log`
#[root@k8s-master tmp]# echo $join
#kubeadm join 10.211.55.36:6443 --token abcdef.0123456789abcdef \ --discovery-token-ca-cert-hash sha256:5ec9be102fc74483e9791517c79cca733ff577d6b0bcf1ca66ae928d448db9a8
ssh k8s-slave1 '${$join}'
ssh k8s-slave2 '${$join}'

#网络插件
wget https://gitee.com/chengkanghua/script/raw/master/k8s/kube-flannel.yml
sed -i '/kube-subnet-mgr/a\ \ \ \ \ \ \ \ - --iface=eth0' kube-flannel.yml
kubectl apply -f kube-flannel.yml
kubectl -n kube-flannel get po -owide
}

#---------------------------------
#集群设置
sting_cluster(){
#设置master节点是否可调度（可选）
kubectl taint node k8s-master node-role.kubernetes.io/master:NoSchedule-
kubectl taint node k8s-master node-role.kubernetes.io/control-plane:NoSchedule-
#设置kubectl自动补全
yum install bash-completion -y
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

#调整证书过期
wget https://gitee.com/chengkanghua/script/raw/master/k8s/update-kubeadm-cert.sh
bash update-kubeadm-cert.sh all
}

#--------------------------------
#安装nerdctl
inst_nerdctl(){
wget https://github.com/containerd/nerdctl/releases/download/v0.23.0/nerdctl-0.23.0-linux-amd64.tar.gz
tar xvf nerdctl-0.23.0-linux-amd64.tar.gz
cp nerdctl /usr/bin/
scp nerdctl k8s-slave1:/usr/bin/
scp nerdctl k8s-slave2:/usr/bin/
}


main(){
	echo $#
	if [ $# -lt 2 ];then
		echo Usage: ${0} k8s-master-ip k8s-slave1-ip k8s-slave1-ip...
	fi	
	for ((i = 1;i <= $#; i++))
	do
		echo $i

	done
	# k8s-master=$1


}

main



