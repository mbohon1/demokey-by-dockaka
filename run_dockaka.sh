#!/bin/bash

# Yêu cầu người dùng nhập key
echo "Vui lòng nhập key:"
read key

# Kiểm tra key có trong file key.txt hay không
if grep -Fxq "$key" key.txt
then
    # Giải mã file dockaka.sh
    openssl enc -aes-256-cbc -d -in dockaka.sh.enc -out dockaka.sh -k "$key" -pbkdf2
    
    # Chạy file dockaka.sh
    bash dockaka.sh
    
    # Xóa file dockaka.sh sau khi chạy
    rm dockaka.sh
else
    echo "Key không hợp lệ!"
fi
