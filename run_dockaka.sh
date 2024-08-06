#!/bin/bash

# Tích hợp nội dung của key duy nhất
KEYS=("dockaka-060824-12ab34cd56ef78gh90ij12kl34mn56op78qr")

# Tích hợp nội dung của run_dockaka.sh.sha256
EXPECTED_CHECKSUM="a61ffe3e55bb012a01fe8899d696cf2b1256d5bf88c1dda54fa37a9981d222f3"

# Kiểm tra tính toàn vẹn của script
echo "Kiểm tra tính toàn vẹn của script..."
ACTUAL_CHECKSUM=$(sha256sum run_dockaka.sh | awk '{print $1}')
if [ "$ACTUAL_CHECKSUM" != "$EXPECTED_CHECKSUM" ]; then
    echo "Script đã bị chỉnh sửa. Dừng thực hiện."
    exit 1
fi

# Yêu cầu người dùng nhập key
echo "Vui lòng nhập key:"
read key

# Kiểm tra key có trong danh sách key hay không
if [[ " ${KEYS[@]} " =~ " ${key} " ]]; then
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
