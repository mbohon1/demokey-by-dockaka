#!/bin/bash

# Tích hợp nội dung của key.txt
KEYS=("dockaka-060824-12ab34cd56ef78gh90ij12kl34mn56op78qr"
      "dockaka-060824-23bc45de67fg89hi01jk23lm45no67pq89st"
      "dockaka-060824-34cd56ef78gh90ij12kl34mn56op78qr90uv"
      "dockaka-060824-45de67fg89hi01jk23lm45no67pq89st01wx"
      "dockaka-060824-56ef78gh90ij12kl34mn56op78qr90uv12yz"
      "dockaka-060824-67fg89hi01jk23lm45no67pq89st01wx23ab"
      "dockaka-060824-78gh90ij12kl34mn56op78qr90uv12yz34cd"
      "dockaka-060824-89hi01jk23lm45no67pq89st01wx23ab45ef"
      "dockaka-060824-90ij12kl34mn56op78qr90uv12yz34cd56gh"
      "dockaka-060824-01jk23lm45no67pq89st01wx23ab45ef67ij")

# Tích hợp nội dung của run_dockaka.sh.sha256
EXPECTED_CHECKSUM="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

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
