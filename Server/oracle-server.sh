sudo tee /etc/yum.repos.d/mongodb-org-6.0.repo << EOF
[mongodb-org-6.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/6.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
EOF

sudo tee /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl Repository
baseurl=https://repo.pritunl.com/stable/yum/oraclelinux/8/
gpgcheck=1
enabled=1
EOF

sudo yum -y install oracle-epel-release-el8
sudo yum-config-manager --enable ol8_developer_EPEL
sudo yum -y update

# WireGuard Server Support
sudo yum -y install wireguard-tools

sudo yum -y remove iptables-services
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service

# Import signing key from keyserver
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; sudo rpm --import key.tmp; rm -f key.tmp
# Alternative import from download if keyserver offline
sudo rpm --import https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc

# Install updated openvpn package from pritunl
sudo yum --allowerasing install pritunl-openvpn

sudo yum -y install pritunl mongodb-org
sudo systemctl enable mongod pritunl
sudo systemctl start mongod pritunl
