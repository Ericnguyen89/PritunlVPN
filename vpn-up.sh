echo " ĐÃ CÀI ĐẶT XONG CÁC SERVICES CẦN THIẾT..."

while true; do
    # Đọc đầu vào từ người dùng
    echo "Nhập vào profile VPN dưới dạng links:"
    read vpn_string

    # Kiểm tra xem chuỗi có chứa "pritunl://" hay không
    if [[ "vpn_string" == *"pritunl://"* ]]; then
        # Thực hiện lệnh thêm profile VPN
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
            echo "Ping KẾT NỐI ĐẾN GATEWAY VPN"
            ping -c 4 "10.3.4.1" | head -n 4 
        else
            echo "Kết thúc chương trình."
        fi
        break
    else
        echo "Sai định dạng! Chuỗi phải chứa dạng pritunl://...... Vui lòng nhập lại."
    fi
done
