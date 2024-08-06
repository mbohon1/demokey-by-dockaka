#!/bin/bash

# URL chứa key
KEY_URL="https://www.evernote.com/shard/s415/sh/8d680a38-4abe-0c18-db7f-8b968daa5536/VnamtwkbReSKgMmIBEE4dA5OqJ_ef1-MSKsseILnUbtO5s2vqls2NTyC0Q"

# Tải key từ URL
KEYS=$(curl -s $KEY_URL)

# Yêu cầu người dùng nhập key
echo "Vui lòng nhập key:"
read key

# Kiểm tra key có trong danh sách key hay không
if echo "$KEYS" | grep -Fxq "$key"; then
    # Kiểm tra thời gian sử dụng key
    start_date=$(date -d "2023-06-01" +%s)  # Ngày bắt đầu sử dụng key
    current_date=$(date +%s)
    diff_days=$(( (current_date - start_date) / 86400 ))

    if [ $diff_days -le 31 ]; then
        # Giải mã file dockaka.sh
        openssl enc -aes-256-cbc -d -in dockaka.sh.enc -out dockaka.sh -k "$key" -pbkdf2
        
        # Chạy file dockaka.sh
        bash dockaka.sh
        
        # Xóa file dockaka.sh sau khi chạy
        rm dockaka.sh
    else
        echo "Key đã hết hạn sử dụng!"
    fi
else
    echo "Key không hợp lệ!"
fi
