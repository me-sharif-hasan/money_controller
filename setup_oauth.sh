#!/bin/bash

# Quick OAuth Setup Helper
# This script provides your SHA-1 and setup instructions

echo "========================================"
echo "Google OAuth Setup for Money Controller"
echo "========================================"
echo ""

# Get SHA-1
echo "📋 Your SHA-1 Certificate Fingerprint:"
echo "----------------------------------------"
SHA1=$(cd android && ./gradlew signingReport 2>&1 | grep "SHA1:" | head -1 | cut -d' ' -f2)
echo "$SHA1"
echo ""

# Instructions
echo "✅ Setup Steps:"
echo "----------------------------------------"
echo "1. Open: https://console.cloud.google.com/"
echo ""
echo "2. Select project: money-controller-c5eee"
echo ""
echo "3. Enable APIs:"
echo "   - APIs & Services → Library"
echo "   - Enable: Google Drive API"
echo "   - Enable: Google Sign-In API"
echo ""
echo "4. Create OAuth Client:"
echo "   - APIs & Services → Credentials"
echo "   - CREATE CREDENTIALS → OAuth client ID"
echo "   - Type: Android"
echo "   - Name: Money Controller Android"
echo "   - Package: com.iishanto.money_controller"
echo "   - SHA-1: $SHA1"
echo ""
echo "5. Configure OAuth Consent Screen (if needed):"
echo "   - User Type: External"
echo "   - App name: Money Controller"
echo "   - Add your email as test user"
echo "   - Scopes: drive.appdata, drive.file"
echo ""
echo "6. Download Configuration:"
echo "   - After creating OAuth client"
echo "   - Download updated google-services.json"
echo "   - Replace: android/app/google-services.json"
echo ""
echo "7. Clean rebuild:"
echo "   flutter clean && flutter pub get && flutter run"
echo ""
echo "========================================"
echo "📖 For detailed guide, see:"
echo "   FIX_SIGN_IN_FAILED.md"
echo "========================================"
echo ""

# Copy SHA-1 to clipboard if xclip is available
if command -v xclip &> /dev/null; then
    echo "$SHA1" | xclip -selection clipboard
    echo "✅ SHA-1 copied to clipboard!"
    echo ""
fi

# Verify current google-services.json status
echo "🔍 Checking current google-services.json..."
if grep -q '"oauth_client": \[\]' android/app/google-services.json; then
    echo "⚠️  WARNING: oauth_client is empty!"
    echo "   You need to configure OAuth in Google Cloud Console"
elif grep -q '"oauth_client":' android/app/google-services.json; then
    echo "✅ OAuth client found in google-services.json"
    echo "   If sign-in still fails, try:"
    echo "   1. Download fresh google-services.json"
    echo "   2. flutter clean && flutter pub get"
else
    echo "⚠️  Could not parse google-services.json"
fi

echo ""
echo "========================================"

