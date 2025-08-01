#!/bin/bash
# Enable root SSH login & password authentication
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'root:YourPasswordHere' | chpasswd
systemctl restart sshd

# Update & install MariaDB 10.5
dnf update -y
dnf install -y mariadb105-server
systemctl enable mariadb
systemctl start mariadb

# Secure MariaDB (non-interactive)
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourDBRootPassword';"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "FLUSH PRIVILEGES;"

# Create WordPress database & user
DB_IP="172.31.26.108"
mysql -u root -pYourDBRootPassword -e "CREATE DATABASE \\`WP-DATABASE\\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -u root -pYourDBRootPassword -e "CREATE USER 'user_lawal'@'3.80.51.156' IDENTIFIED BY 'YourDBUserPassword';"
mysql -u root -pYourDBRootPassword -e "GRANT ALL PRIVILEGES ON \\`WP-DATABASE\\`.* TO 'user_lawal'@'3.80.51.156';"
mysql -u root -pYourDBRootPassword -e "FLUSH PRIVILEGES;"

# Format and mount EBS volumes
mkfs.ext4 /dev/sdb
mkdir -p /mnt/dbdisk
mount /dev/sdb /mnt/dbdisk
echo '/dev/sdb /mnt/dbdisk ext4 defaults,nofail 0 2' >> /etc/fstab

mkfs.ext4 /dev/sdc
mkdir -p /mnt/dbbackup
mount /dev/sdc /mnt/dbbackup
echo '/dev/sdc /mnt/dbbackup ext4 defaults,nofail 0 2' >> /etc/fstab 