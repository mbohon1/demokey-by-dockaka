#!/bin/bash

# Kiểm tra tính toàn vẹn của script
echo "Kiểm tra tính toàn vẹn của script..."
sha256sum -c run_dockaka.sh.sha256 --status
if [ $? -ne 0 ]; then
    echo "Script đã bị chỉnh sửa. Dừng thực hiện."
    exit 1
fi

# Yêu cầu người dùng nhập key
echo "Vui lòng nhập key:"
read key

# Kiểm tra key có trong file key.txt hay không
if grep -Fxq "$key" key.txt
then
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
