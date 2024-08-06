#!/bin/bash

# Đọc nội dung của key.txt
keys=$(cat key.txt)

# Lấy ngày hiện tại
current_date=$(date +%Y%m%d)

# Hàm kiểm tra tính hợp lệ của key
check_key_validity() {
    key_date=$(echo $1 | cut -d'-' -f2)
    key_date_formatted="20${key_date:4:2}${key_date:2:2}${key_date:0:2}"
    expiry_date=$(date -d "$key_date_formatted +30 days" +%Y%m%d)
    
    if [ "$current_date" -le "$expiry_date" ]; then
        echo "Key $1 is valid."
    else
        echo "Key $1 has expired."
    fi
}

# Kiểm tra từng key
for key in $keys; do
    check_key_validity $key
done
