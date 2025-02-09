#!/bin/bash

# URL chứa key (được mã hóa để không hiển thị trực tiếp)
ENCRYPTED_URL="aHR0cDovLzY5LjI4Ljg4Ljc5L3Rlc3Qta2V5L2tleS50eHQ="

# Giải mã URL
KEY_URL=$(echo $ENCRYPTED_URL | base64 --decode)

# Tải key từ URL
keys=$(curl -s $KEY_URL)

# In ra danh sách key để debug
echo "Danh sách key đã tải:"
echo "$keys"

# Lấy ngày hiện tại
current_date=$(date +%Y%m%d)

# Hàm kiểm tra tính hợp lệ của key
check_key_validity() {
    key_date=$(echo $1 | cut -d'-' -f2)
    key_date_formatted="20${key_date:4:2}${key_date:2:2}${key_date:0:2}"
    expiry_date=$(date -d "$key_date_formatted +31 days" +%Y%m%d)
    
    if [ "$current_date" -le "$expiry_date" ]; then
        echo "Key $1 is valid."
        return 0
    else
        echo "Key $1 has expired."
        return 1
    fi
}

# Yêu cầu người dùng nhập key
echo "Vui lòng nhập key:"
read user_key

# Kiểm tra key người dùng nhập có bắt đầu bằng "dockaka-" và có trong danh sách key hay không
if [[ "$user_key" == dockaka-* ]] && echo "$keys" | grep -Fxq "$user_key"; then
    if check_key_validity $user_key; then
        # Giải mã file dockaka.sh.enc
        openssl enc -aes-256-cbc -d -in dockaka.sh.enc -out dockaka.sh -k "$user_key" -pbkdf2
        
        # Chạy file dockaka.sh
        bash dockaka.sh
        
        # Xóa file dockaka.sh sau khi chạy
        rm dockaka.sh
    fi
else
    echo "Key không hợp lệ! Vui lòng kiểm tra lại key hoặc liên hệ với quản trị viên."
fi
