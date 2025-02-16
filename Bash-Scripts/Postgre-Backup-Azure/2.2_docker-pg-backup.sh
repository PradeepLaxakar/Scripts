#!/bin/bash

# Define variables
BACKUP_DIR=~/pg_backup
DB_NAME=DB-NAME
DB_USER=DB-USER
DB_CONTAINER_NAME=DB-CONTAINER-NAME  # Name of the PostgreSQL container as defined in docker-compose
TIMESTAMP=$(date +%F-%H-%M)
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$TIMESTAMP.tar"

# Ensure the backup directory exists
mkdir -p $BACKUP_DIR

# Run pg_dump to create the backup in custom format inside the PostgreSQL container
docker exec -u postgres $DB_CONTAINER_NAME pg_dump -U $DB_USER -F c -f /tmp/$DB_NAME-$TIMESTAMP.tar $DB_NAME

# Copy the backup file from the container to the host
docker cp $DB_CONTAINER_NAME:/tmp/$DB_NAME-$TIMESTAMP.tar $BACKUP_DIR

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Database backup created: $BACKUP_FILE"
else
    echo "Error creating database backup."
    exit 1
fi

# Clean up the temporary file in the container
docker exec -u postgres $DB_CONTAINER_NAME rm /tmp/$DB_NAME-$TIMESTAMP.tar
