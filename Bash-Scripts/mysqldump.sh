#!/bin/bash

# Set the password for mySQL-server user
export PGPASSWORD='PASSWORD'

# Replace these values with your actual Azure Blob Storage account details
AZURE_STORAGE_ACCOUNT="STORAGE-ACCOUNT-NAME"
AZURE_STORAGE_ACCESS_KEY="ACCESS-KEY"
CONTAINER_NAME="MODULE-db-backup"

# Define variables for the backup
USERNAME=DB-USERNAME
DATABASE_NAME=DB-NAME

# Get the current date and time
today=$(date +"%Y-%m-%d_%H-%M-%S")
todayDate=$(date +"%Y-%m-%d")

# Set the filenames to todays date. 
BACKUP_FILE=/PATH/backup_$today.sql
BACKUP_ZIPFILE=/PATH/backup_$today.tar.gz

# Perform the backup using pg_dump
mysqldump -U $USERNAME -d $DATABASE_NAME > $BACKUP_FILE

# Unset the password to clear it from the environment
unset PGPASSWORD

# Generating a compressed file using tar
tar -czvf $BACKUP_ZIPFILE $BACKUP_FILE

# Upload the backup files to Azure Blob Storage using Azure CLI
# using -d for directory using the $todayDate variable to store the files based on dates
az storage blob directory upload --account-name $AZURE_STORAGE_ACCOUNT --account-key $AZURE_STORAGE_ACCESS_KEY --container $CONTAINER_NAME --source $BACKUP_ZIPFILE -d $todayDate


# The final step is to set the cron so that our script gets executed every hour.
# crontab -e
# 0 * * * * /PATH/scripts/backup_script.sh

