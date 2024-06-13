sudo apt update -y
sudo apt install wireguard-tools -y
sudo apt install resolvconf -y

sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt noble main
EOF

sudo apt --assume-yes install gnupg
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
sudo apt update
sudo apt install pritunl-client-electron jq -y

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

ba_ky_tu=${first_id:0:3}

pritunl-client enable $ba_ky_tu

read -p "Nhấn Y và Enter để tiếp tục: " choice
# Kiểm tra xem người dùng đã nhấn "Y" hay chưa
if [ "$choice" == "Y" ] || [ "$choice" == "y" ]; then
  # Start profile VPN
    pritunl-client start $ba_ky_tu -m wg
    echo "ĐÃ KÍCH HOẠT VPN PROFILE ID: $first_id"
   
else
    echo "Kết thúc chương trình."
fi
