sudo apt update -y
sudo apt install wireguard-tools -y
sudo apt install resolvconf -y

sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt jammy main
EOF

sudo apt --assume-yes install gnupg
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
sudo apt update -y
sudo apt install pritunl-client-electron -y

wget https://raw.githubusercontent.com/Ericnguyen89/PriturnVPN/main/vpn-up.sh && sudo bash vpn-up.sh
