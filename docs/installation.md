# Installation & Configuration Guide

Follow these steps to reproduce the environment.

## 1. Launch EC2 Instances

- **App-server**
  - AMI: Amazon Linux 2
  - User Data: `scripts/user_data_app.sh`
  - Security Group: Allow 22 (SSH), 80 (HTTP)
  
- **DB-server**
  - AMI: Amazon Linux 2023
  - User Data: `scripts/user_data_db.sh`
  - Security Group: Allow 22 from App-server private IP only

## 2. Attach EBS Volumes to DB-server

- Create a 10 GiB volume in the same AZ → attach as `/dev/sdb`
- Create a 5 GiB volume in the same AZ → attach as `/dev/sdc`

## 3. Verify Mounts & Filesystems

```bash
lsblk    # confirm /dev/sdb and /dev/sdc
mount    # ensure /mnt/dbdisk and /mnt/dbbackup are mounted
```

## 4. Secure MariaDB (if not automated)
bash
```
mysql_secure_installation
``` 

## 5. Test Database Connection from App-server
```bash
mysql -h 172.31.26.108 -u user_lawal -pYourDBUserPassword WP-DATABASE
```

## 6. Complete WordPress Setup

- Open browser: http://3.80.51.156
- Follow WordPress wizard
- Configure database:
- Database Host: 172.31.26.108
- Database Name: WP-DATABASE
- Database User: user_lawal
- Database Password: (as set in DB-server script)
 
https://screenshots/04-wordpress-install.png

## 7. Configure Cron for Daily Backups
```bash
sudo dnf install -y cronie
sudo systemctl enable crond
sudo systemctl start crond
sudo crontab -e
Add the following cron job:
```

cron
```
0 2 * * * /usr/local/bin/backup_wp_db.sh >> /var/log/wp_db_backup.log 2>&1
```
## 8. Validate Backup
```bash
ls /mnt/dbbackup
# Should show files named wp-db-YYYY-MM-DD-HH-MM.sql
```
https://screenshots/05-cron-backup-success.png