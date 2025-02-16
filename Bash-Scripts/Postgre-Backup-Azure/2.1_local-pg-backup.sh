#!/bin/bash

# Define variables
BACKUP_DIR=~/pg_backup
DB_NAME=DB-NAME
DB_USER=USERNAME
DB_HOST=localhost
VM_USER=VM-USERNAME  # vm user name
TIMESTAMP=$(date +\%F-\%H-\%M)
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$TIMESTAMP.tar"

# Ensure the backup directory exists
mkdir -p $BACKUP_DIR

# Run pg_dump to create the backup in custom format
sudo -u $VM_USER pg_dump -h $DB_HOST -U $DB_USER -F c -f $BACKUP_FILE $DB_NAME

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Database backup created: $BACKUP_FILE"
else
    echo "Error creating database backup."
    exit 1
fi
