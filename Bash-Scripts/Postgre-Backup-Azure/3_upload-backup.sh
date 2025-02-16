#!/bin/bash

# Define variables
BACKUP_DIR=~/pg_backup
CONTAINER_NAME="DB-CONTAINER-NAME"
STORAGE_ACCOUNT_NAME="STORAGE-ACCOUNT"
SAS_TOKEN="SAS-TOKEN"
STORAGE_URL="https://$STORAGE_ACCOUNT_NAME.blob.core.windows.net/$CONTAINER_NAME/?$SAS_TOKEN"
TEAMS_WEBHOOK_URL="TEAMS-WEBHOOK-URL-TO-SEND-NOTIFICATION"

# Ensure azcopy is installed
if ! command -v azcopy &> /dev/null
then
    echo "azcopy could not be found. Please install it and try again."
    exit 1
fi

# Loop through all .tar files in the backup directory
for BACKUP_FILE in $BACKUP_DIR/*.tar
do
    # Check if the file exists
    if [ ! -f "$BACKUP_FILE" ]; then
        echo "No backup files found in $BACKUP_DIR."
        exit 1
    fi

    # Upload the backup file to Azure Blob Storage
    azcopy copy "$BACKUP_FILE" "$STORAGE_URL"

    # Check if the upload was successful
    if [ $? -eq 0 ]; then
        echo "Backup file uploaded to Azure Blob: $BACKUP_FILE"

        # Send success notification to Teams
        curl -H "Content-Type: application/json" -d '{
          "text": "Dev: Backup file uploaded successfully: '"$BACKUP_FILE"'"
        }' $TEAMS_WEBHOOK_URL

        # Delete the local backup file after successful upload
        rm "$BACKUP_FILE"
        echo "Local backup file deleted: $BACKUP_FILE"
    else
        echo "Error uploading backup file to Azure Blob: $BACKUP_FILE"
        
        # Send failure notification to Teams
        curl -H "Content-Type: application/json" -d '{
          "text": "Error uploading backup file: '"$BACKUP_FILE"'"
        }' $TEAMS_WEBHOOK_URL
    fi
done