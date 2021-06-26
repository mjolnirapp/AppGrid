#!/usr/bin/env bash

CURVER=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" AppGrid/AppGrid-Info.plist)

MAJOR=$(echo "$CURVER" | awk -F "." '{print $1}')
MINOR=$(echo "$CURVER" | awk -F "." '{print $2}')
PATCH=$(echo "$CURVER" | awk -F "." '{print $3}')

MSG=$(git log -1 --format=%s)

# Follow conventaional commits?
# https://www.conventionalcommits.org/en/v1.0.0/
case $MSG in
  "fix"*)
          PATCH=$(($PATCH + 1))
    ;;
  "feat"*)
          MINOR=$(($MINOR + 1))
          PATCH="0"
    ;;
  "BREAKING CHANGE"*)
          MAJOR=$(($MAJOR + 1))
          MINOR="0"
          PATCH="0"
    ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_VERSION" AppGrid/AppGrid-Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEW_VERSION" AppGrid/AppGrid-Info.plist
