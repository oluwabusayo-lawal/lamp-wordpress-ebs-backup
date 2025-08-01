#!/bin/bash
# Database backup script
TIMESTAMP=$(date +"%F-%H-%M")
BACKUP_DIR="/mnt/dbbackup"
DB_NAME="WP-DATABASE"
DB_USER="root"
DB_PASS="YourDBRootPassword"

echo "Backing up $DB_NAME to $BACKUP_DIR/wp-db-$TIMESTAMP.sql"
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/wp-db-$TIMESTAMP.sql