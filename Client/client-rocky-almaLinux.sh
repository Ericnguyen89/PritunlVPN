sudo tee -a /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl Stable Repository
baseurl=https://repo.pritunl.com/stable/yum/almalinux/9/
gpgcheck=1
enabled=1
EOF

gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; sudo rpm --import key.tmp; rm -f key.tmp
sudo yum -y install epel-release
sudo yum -y update
sudo yum -y install pritunl-client-electron wireguard-tools jq
 
#Fix lỗi tự disconnect wireguard interface khi start profile pritunl
sudo systemctl start systemd-resolved
sudo systemctl enable systemd-resolved
sudo sed -i '/\[main\]/a dns=systemd-resolved' /etc/NetworkManager/NetworkManager.conf
sudo rm -f /etc/resolv.conf
sudo ln -s /usr/lib/systemd/resolv.conf /etc/resolv.conf
sudo systemctl restart NetworkManager
# ---------------------------
echo " ĐÃ CÀI ĐẶT XONG CÁC SERVICES CẦN THIẾT..."
echo "Nhập vào profile VPN dưới dạng links:"
read vpn_string
#Thực hiện lệnh thêm profile VPN
pritunl-client add $vpn_string

# Read the JSON data from the file and extract the "id" field
pritunl-client list -j > tmp.json
id_field=$(jq -r '.[0].id' tmp.json)

# Extract the first three words from the "id" field
first_id=$(echo "$id_field" | cut -d' ' -f1-3)

# Print the result
pritunl-client list
echo "ID of VPN profile is: $first_id"

#ba_ky_tu=${first_id:0:3}

pritunl-client enable $first_id

read -p "Nhấn Y và Enter để bật VPN profile: $first_id >" choice
# Kiểm tra xem người dùng đã nhấn "Y" hay chưa
if [ "$choice" == "Y" ] || [ "$choice" == "y" ]; then
  # Start profile VPN
    pritunl-client start $first_id -m wg
    echo "ĐÃ KÍCH HOẠT VPN PROFILE ID: $first_id Wireguard tunnel.."
   
else
    echo "Kết thúc chương trình."
fi
