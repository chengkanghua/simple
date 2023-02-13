#!/bin/bash
: ' 
description:  k8s1.24 一键安装脚本
author:       chengkanghua
email：       chengkanghua@foxmail.com
wechar        343264992
date：        2023-2-12
'
. /etc/init.d/functions
# set -x  #查看执行过程


#--------------------------------------
#批量分发公钥
dispense(){
	#配置yum源 yum源要存在必须要是aliyun
    if [ ! -f /etc/yum.repos.d/CentOS-Base.repo ] && [ ! -f /etc/yum.repos.d/Centos-7.repo ] && [ `grep aliyun Centos-7.repo CentOS-Base.repo |wc -l` -lt 50 ];then
        rm -rf /etc/yum.repos.d/*
        curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
        curl -o /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    fi

	[ -f /usr/bin/sshpass ] || yum install -y sshpass
	#sshpass 简单使用说明
	# sshpass -p '1' ssh root@10.211.55.37 'df -h'
	# export SSHPASS='1' #密码加全局变量
	# sshpass -e ssh root@10.211.55.37 'df -h'
	#关闭ssh连接询问
	sed -i '/StrictHostKeyChecking/aStrictHostKeyChecking no' /etc/ssh/ssh_config

	#非交互创建密钥对
	[ -f ~/.ssh/id_rsa ] || ssh-keygen -t RSA -N '' -f ~/.ssh/id_rsa
	#非交互分发公钥
	# sshpass -p1 ssh-copy-id -f -i ~/.ssh/id_rsa.pub "-o StrictHostKeyChecking=no" 10.211.55.37
	#批量分发
	for ip in $@
	do
	  sshpass -p1 ssh-copy-id -f -i ~/.ssh/id_rsa.pub "-o StrictHostKeyChecking=no" $ip &> /dev/null && action "$host 公钥分发成功" /bin/true || action "$host 公钥分发失败" /bin/false
	done
}


#------------------------------------------
#配置host
init_host(){
. /etc/init.d/functions
localhost_ip=$(ifconfig eth0|grep 'inet.*netmask'|cut -d ' ' -f10)
status=$(grep $localhost_ip /etc/hosts|wc -l)
if [ $status -eq 0 ];then
	echo "${localhost_ip} k8s-master" >> /etc/hosts
	hostnamectl set-hostname k8s-master && action "本机hostname设置成功" /bin/true || action "本机hostname失败" /bin/false 
fi


for ((i = 1;i <= $#;i++))
do
	if [ `grep "k8s-slave$i" /etc/hosts|wc -l` -eq 0 ];then
		echo "`eval echo '$'"${i}"` k8s-slave$i" >> /etc/hosts
		ssh `eval echo '$'"${i}"` "hostnamectl set-hostname k8s-slave$i" && action "`eval echo '$'"${i}"` set-hostname k8s-slave$i" /bin/true || action "`eval echo '$'"${i}"` set-hostname k8s-slave$i" /bin/false 
	fi
done

#同步hosts文件到note节点上
for host in $@
do
	scp /etc/hosts $host:/etc/hosts 
done
}
#-------------------------------------
#调整系统配置
base_sys(){
. /etc/init.d/functions
echo 'base_sys  begin.... '
if [ `grep SELINUX=disabled /etc/selinux/config |wc -l` -ne 2 ];then
iptables -P FORWARD ACCEPT
swapoff -a
sed -ri '/ swap / s/(.*)/#\1/g' /etc/fstab
sed -ri 's#(SELINUX=).*#\1disabled#' /etc/selinux/config
setenforce 0
systemctl disable firewalld && systemctl stop firewalld

fi


if [ ! -f /etc/sysctl.d/k8s.conf ];then
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward=1
vm.max_map_count=262144
EOF
modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf
fi

#配置yum源
# rm -rf /etc/yum.repos.d/*
# curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
# curl -o /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo
if [ ! -f /etc/yum.repos.d/docker-ce.repo ] && [ ! -f /etc/yum.repos.d/kubernetes.repo ];then
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
fi

yum_repo=$(rpm -qa |grep -E 'bash-completion|net-tools|wget|psmisc'|wc -l)
if [ $yum_repo -ge 4 ];then
	action '调整系统配置ok ' /bin/true || action '调整系统配置失败 ' /bin/false
else
	yum install -y bash-completion net-tools vim wget nc psmisc && action '调整系统配置ok ' /bin/true || action '调整系统配置失败 ' /bin/false
fi

echo 'base_sys  end.... '

}



#---------------------------------------
#所有节点安装docker
inst_docker(){

echo 'install_docker  begin.... '
yum_repo=$(rpm -qa docker-ce |wc -l)
if [ $yum_repo -eq 0 ];then
yum install docker-ce-20.10.18 -y

cat > /etc/docker/daemon.json<<EOF
{                         
  "registry-mirrors" : [
    "https://8xpk5wnt.mirror.aliyuncs.com"
  ]
}
EOF
systemctl enable docker && systemctl start docker
fi

echo 'install_docker  end.... '

}


#-------------------------------------
#初始化集群 所有节点
init_cluster(){

echo 'init_cluster  begin.... '
yum_repo=$(rpm -qa kubelet-1.24.4 kube* |wc -l)
if [ $yum_repo -ne 4 ];then
yum install -y kubelet-1.24.4 kubeadm-1.24.4 kubectl-1.24.4 --disableexcludes=kubernetes
systemctl enable kubelet 
fi

#配置containerd
if [ ! -f /etc/containerd/certs.d/docker.io/hosts.toml ];then
containerd config default > /etc/containerd/config.toml
sed -i "s#k8s.gcr.io/pause#registry.aliyuncs.com/google_containers/pause#g" /etc/containerd/config.toml
sed -i "s#registry.k8s.io/pause#registry.aliyuncs.com/google_containers/pause#g" /etc/containerd/config.toml
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
fi

echo 'init_cluster  end.... '
}


#------------------------------------------
#mater节点初始化
init_master(){

if [ ! -f /tmp/kubeadm_init.log ];then
kubeadm config print init-defaults > kubeadm.yaml

localhost_ip=$(ifconfig eth0|grep 'inet.*netmask'|cut -d ' ' -f10)
sed -ri "s#(advertiseAddress: ).*#\1${localhost_ip}#" kubeadm.yaml
sed -ri 's#(name: ).*#\1k8s-master#' kubeadm.yaml
sed -ri 's#(imageRepository: ).*#\1registry.aliyuncs.com/google_containers#' kubeadm.yaml
sed -ri 's#(kubernetesVersion: ).*#\11.24.4#' kubeadm.yaml
sed -i '/dnsDomain:/a\ \ podSubnet: 10.244.0.0/16' kubeadm.yaml

kubeadm config images list --config kubeadm.yaml
kubeadm config images pull --config kubeadm.yaml
kubeadm init --config kubeadm.yaml >/tmp/kubeadm_init.log
mkdir -p $HOME/.kube
/usr/bin/cp /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

#添加slave节点到集群中
join=`grep -E 'kubeadm join.*|sha256' /tmp/kubeadm_init.log`
join=$(echo $join|sed "s:\\\::g") #去掉\
#[root@k8s-master tmp]# echo $join
#kubeadm join 10.211.55.36:6443 --token abcdef.0123456789abcdef \ --discovery-token-ca-cert-hash sha256:5ec9be102fc74483e9791517c79cca733ff577d6b0bcf1ca66ae928d448db9a8
for host in $@
do
	ssh $host "${join}"
done

if [ `kubectl get node|grep k8s|wc -l` -gt $# ];then
	action 'node节点上线成功' /bin/true
else
	action 'node节点上线数量有问题，请检查' /bin/false
fi

#网络插件
wget https://gitee.com/chengkanghua/script/raw/master/k8s/kube-flannel.yml
sed -i '/kube-subnet-mgr/a\ \ \ \ \ \ \ \ - --iface=eth0' kube-flannel.yml
kubectl apply -f kube-flannel.yml
# kubectl -n kube-flannel get po -owide

fi


#节点没加入成功从新生成
# join=$(kubeadm token create --print-join-command) #去掉\
# for host in $@
# do
# 	ssh $host "${join}"
# done

# if [ `kubectl get node|grep k8s|wc -l` -gt $# ];then
# 	action 'node节点上线成功' /bin/true
# else
# 	action 'node节点上线数量有问题，请检查' /bin/false
# fi


}

#---------------------------------
#集群设置
sting_cluster(){
#设置master节点是否可调度（可选）
kubectl taint node k8s-master node-role.kubernetes.io/master:NoSchedule-
kubectl taint node k8s-master node-role.kubernetes.io/control-plane:NoSchedule-
#设置kubectl自动补全
# yum install bash-completion -y
source /usr/share/bash-completion/bash_completion
# $(source <(kubectl completion bash)) 
echo "source <(kubectl completion bash)" >> ~/.bashrc
source ~/.bashrc

#调整证书过期
wget https://gitee.com/chengkanghua/script/raw/master/k8s/update-kubeadm-cert.sh
bash update-kubeadm-cert.sh all
}

#--------------------------------
#安装nerdctl
inst_nerdctl(){
status=$(ls /usr/bin/nerdctl|wc -l)
if [ $status -ne 1 ];then
wget -c -t 10 https://github.com/containerd/nerdctl/releases/download/v0.23.0/nerdctl-0.23.0-linux-amd64.tar.gz
tar xvf nerdctl-0.23.0-linux-amd64.tar.gz
cp nerdctl /usr/bin/
fi

for host in $@
do
	scp /usr/bin/nerdctl $host:/usr/bin/
done

}


main(){
# localhost_ip=$(ifconfig eth0|grep 'inet.*netmask'|cut -d ' ' -f10)
# all_host=$localhost_ip' '$@
	# dispense $@
	# init_host $@
	base_sys
	inst_docker
	init_cluster

# #调整所有node节点系统设置
for host in $@
do
	ssh $host "$(typeset -f base_sys); base_sys"  #运行base_sys
	ssh $host "$(typeset -f inst_docker); inst_docker" 
	ssh $host "$(typeset -f init_cluster); init_cluster" 
done

	init_master $@
	# sting_cluster
	# inst_nerdctl $@
    echo "end"
}
	



help() {
    echo Usage: ${0} k8s-slave1-ip k8s-slave1-ip...
}

if [ $# -lt 1 ] || [ $1 == "-h" ];then
	help
    exit 1
fi	

#判断网络
for host in $@
do
   ping -c1 $host &>/dev/null
   if [ $? -ne 0 ];then 
        echo "$host 地址网络不通... "
        exit 1
   fi
done 


main $@

