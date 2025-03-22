#!/bin/bash

# Configuration
BACKUP_DIR="/path/to/backup/directory"
DATE=$(date +%Y%m%d_%H%M%S)
PROJECT_NAME="OneShot"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Backup code
echo "Backing up code..."
tar -czf "$BACKUP_DIR/${PROJECT_NAME}_code_${DATE}.tar.gz" \
    --exclude='.git' \
    --exclude='Pods' \
    --exclude='build' \
    --exclude='DerivedData' \
    .

# Backup Podfile.lock
echo "Backing up Podfile.lock..."
cp Podfile.lock "$BACKUP_DIR/${PROJECT_NAME}_Podfile_${DATE}.lock"

# Backup Xcode project settings
echo "Backing up Xcode project settings..."
tar -czf "$BACKUP_DIR/${PROJECT_NAME}_xcode_${DATE}.tar.gz" \
    *.xcodeproj/project.pbxproj \
    *.xcodeproj/project.xcworkspace

# Clean up old backups (keep last 7 days)
echo "Cleaning up old backups..."
find "$BACKUP_DIR" -name "${PROJECT_NAME}_*" -type f -mtime +7 -delete

echo "Backup completed successfully!" 