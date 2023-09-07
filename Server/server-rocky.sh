# Repo of mongodb
sudo tee /etc/yum.repos.d/mongodb-org-6.0.repo << EOF
[mongodb-org-6.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/6.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
EOF
#Repo of pritunl
sudo tee /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl Repository
baseurl=https://repo.pritunl.com/stable/yum/oraclelinux/8/
gpgcheck=1
enabled=1
EOF
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

sudo yum -y update
# WireGuard server support
sudo yum -y install wireguard-tools
#Remove Service of iptable and firewall
sudo yum -y remove iptables-services
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service
sudo yum -y install pritunl mongodb-org
sudo systemctl enable mongod pritunl
sudo systemctl start mongod pritunl
