#sudo apt install jq -y
pritunl-client list -j > tmp1.json
id_delete=$(jq -r '.[0].id' tmp1.json)

# Extract the first three words from the "id" field
first_id1=$(echo "$id_delete" | cut -d' ' -f1-3)

# Print the result
pritunl-client list
echo "ID of VPN profile is: $first_id1"

ba_ky_tu_del=${first_id1:0:3}

pritunl-client disable $ba_ky_tu_del

read -p "Nhấn Y và Enter để tiếp tục: " choice
# Kiểm tra xem người dùng đã nhấn "Y" hay chưa
if [ "$choice" == "Y" ] || [ "$choice" == "y" ]; then
  # Start profile VPN
    pritunl-client remove $ba_ky_tu_del 
    echo "ĐÃ DELETED PROFILE ID: $first_id1"
    wget https://raw.githubusercontent.com/Ericnguyen89/PriturnVPN/main/vpn-up.sh && sudo bash vpn-up.sh
else
    echo "Kết thúc chương trình."
fi
