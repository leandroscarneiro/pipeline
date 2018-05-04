firewall-cmd --zone=public --add-port=2049/tcp --add-port=111/tcp --add-port=20048/tcp --add-port=20048/udp  --permanent

firewall-cmd --reload

