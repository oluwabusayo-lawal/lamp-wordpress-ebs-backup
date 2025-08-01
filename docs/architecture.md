# Architecture Diagram & Overview

This document describes the network topology and data flow of the deployment.

## Components

1. **App-server (3.80.51.156)**
   - Public-facing web server
   - Runs Apache + PHP + WordPress
   - SSH root login enabled

2. **DB-server (172.31.26.108)**
   - Private-facing database server
   - Runs MariaDB 10.5
   - Two EBS volumes:
     - `/dev/sdb` → Data disk mounted at `/mnt/dbdisk`
     - `/dev/sdc` → Backup disk mounted at `/mnt/dbbackup`

3. **Cron scheduler**
   - Executes `backup_wp_db.sh` daily at 2:00 AM
   - Stores backups on `/mnt/dbbackup`

## Data Flow

```plaintext
User → HTTP → App-server → SQL Queries → DB-server:/mnt/dbdisk
                                   ← Database Responses
Cron@2AM on DB-server: mysqldump → /mnt/dbbackup/wp-db-<timestamp>.sql