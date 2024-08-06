#!/bin/bash

# Mã hóa URL chứa key
ENCRYPTED_URL="U2FsdGVkX1+1eH0lXLxzOouTuo6P3F3c/A7XqjbgKAQvmSqzts95EDqVr2Ph7dX9NbZ0ZVsRnAOtCwhV3JuLIX4FgMlKG8Mnl13EmhmXh6hkYzgQ+8UWxhx1iwSGRZS1XljJCVw1kFqa2YZSiXBLgceWttX4TP/41kv/ROst9+QwsoMlxID0DgYoI9dOhotCxSVUPIOSzYY8gbfON6szGg=="

# Giải mã URL chứa key
KEY_URL=$(echo "$ENCRYPTED_URL" | openssl enc -aes-256-cbc -d -a -pass pass:my_secret_password)

# Tải key từ URL
KEYS=$(curl -s $KEY_URL)

# In ra nội dung của KEYS để debug
echo "Nội dung của KEYS:"
echo "$KEYS"

# Yêu cầu người dùng nhập key
echo "Vui lòng nhập key:"
read key

# In ra key mà người dùng nhập vào để debug
echo "Key người dùng nhập vào: $key"

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
echo "Key không hợp lệ! Vui lòng kiểm tra lại key hoặc liên hệ với quản trị viên."
fi
