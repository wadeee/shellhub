## modify /etc/ssh/sshd_config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i '/^#PermitRootLogin prohibit-password$/a PermitRootLogin yes' /etc/ssh/sshd_config
cat /etc/ssh/sshd_config
systemctl restart sshd
