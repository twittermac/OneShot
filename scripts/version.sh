#!/bin/bash

# Version management script
# Usage: ./version.sh [major|minor|patch]

VERSION_FILE="VERSION"
CURRENT_VERSION=$(cat $VERSION_FILE)

if [ -z "$1" ]; then
    echo "Usage: ./version.sh [major|minor|patch]"
    exit 1
fi

# Split version into major.minor.patch
IFS='.' read -r -a version_parts <<< "$CURRENT_VERSION"
major="${version_parts[0]}"
minor="${version_parts[1]}"
patch="${version_parts[2]}"

case $1 in
    "major")
        major=$((major + 1))
        minor=0
        patch=0
        ;;
    "minor")
        minor=$((minor + 1))
        patch=0
        ;;
    "patch")
        patch=$((patch + 1))
        ;;
    *)
        echo "Invalid version type. Use major, minor, or patch"
        exit 1
        ;;
esac

NEW_VERSION="$major.$minor.$patch"
echo $NEW_VERSION > $VERSION_FILE

# Update Info.plist version
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_VERSION" OneShot/Info.plist

echo "Version updated to $NEW_VERSION" 