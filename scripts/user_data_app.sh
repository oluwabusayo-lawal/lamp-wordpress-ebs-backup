#!/bin/bash
# Enable root SSH login & password authentication
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'root:YourPasswordHere' | chpasswd
systemctl restart sshd

# Update & install Apache, PHP
yum update -y
yum install -y httpd wget php php-mysqlnd
systemctl enable httpd
systemctl start httpd

# Download and configure WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html