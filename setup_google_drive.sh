#!/bin/bash

# Google Drive Backup Setup Helper
# This script helps you set up Google Drive backup feature

echo "========================================"
echo "Google Drive Backup Setup Helper"
echo "========================================"
echo ""

# Get SHA-1 certificate fingerprint
echo "Step 1: Getting SHA-1 Certificate Fingerprint..."
echo "----------------------------------------"
cd android
./gradlew signingReport 2>&1 | grep -A 2 "Variant: debug" | grep "SHA1:"
echo ""

echo "Step 2: Next Steps"
echo "----------------------------------------"
echo "1. Copy the SHA-1 fingerprint above"
echo "2. Go to: https://console.cloud.google.com/"
echo "3. Select project: money-controller-c5eee"
echo "4. Go to: APIs & Services → Credentials"
echo "5. Create OAuth 2.0 Client ID:"
echo "   - Type: Android"
echo "   - Package: com.iishanto.money_controller"
echo "   - SHA-1: [Paste the fingerprint you copied]"
echo ""
echo "6. Enable these APIs:"
echo "   - Google Drive API"
echo "   - Google Sign-In API"
echo ""
echo "7. Download updated google-services.json"
echo "8. Replace: android/app/google-services.json"
echo ""
echo "Done! Now you can test the backup feature."
echo "========================================"

