# Google Drive Backup & Restore - Setup Guide

## Overview
The app now supports automatic backup and restore of all your financial data to Google Drive. This feature works like WhatsApp backup - simple, secure, and manual.

---

## ✅ Features Implemented

### 1. **Google Account Integration**
- Sign in with Google account
- Switch between multiple Google accounts
- Sign out when needed
- Automatic silent sign-in on app restart

### 2. **Backup to Google Drive**
- Upload all app data to Google Drive
- Data stored in app's private folder (appDataFolder)
- Automatic update if backup already exists
- Backup includes:
  - Total money
  - Fixed costs
  - Expenses
  - Vault data and transactions
  - App settings
  - Saving goals
  - Expense goals

### 3. **Restore from Google Drive**
- Download and restore data from Google Drive
- Replace all current data with backup
- Automatic app reload after restore
- Shows backup date and time

### 4. **Security**
- Data stored in Google Drive's appDataFolder (private to your app)
- Not visible in regular Drive file manager
- Requires Google account authentication
- OAuth 2.0 secure authentication

---

## 🔧 Setup Requirements

### 1. Google Cloud Console Setup

You already have `google-services.json` in `/android/app/`. Now you need to add OAuth client:

1. **Go to Google Cloud Console**: https://console.cloud.google.com/
2. **Select your project**: money-controller-c5eee
3. **Navigate to**: APIs & Services → Credentials
4. **Create OAuth 2.0 Client ID**:
   - Application type: Android
   - Package name: `com.iishanto.money_controller`
   - SHA-1 certificate fingerprint: Get it by running:
     ```bash
     cd android
     ./gradlew signingReport
     ```
   - Copy the SHA-1 fingerprint for debug variant

5. **Enable APIs**:
   - Go to: APIs & Services → Library
   - Enable: **Google Drive API**
   - Enable: **Google Sign-In API** (if not already enabled)

6. **Download updated google-services.json**:
   - After creating OAuth client, download the updated `google-services.json`
   - Replace the existing file in `/android/app/google-services.json`

### 2. Get SHA-1 Certificate

Run this command to get your SHA-1:
```bash
cd /home/bs01595/Downloads/money_controller/android
./gradlew signingReport
```

Look for the SHA-1 under "Variant: debug" section.

### 3. Update google-services.json

After adding the OAuth client in Google Cloud Console, your `google-services.json` should have an `oauth_client` section like this:

```json
{
  "project_info": {...},
  "client": [
    {
      "client_info": {...},
      "oauth_client": [
        {
          "client_id": "YOUR-CLIENT-ID.apps.googleusercontent.com",
          "client_type": 1,
          "android_info": {
            "package_name": "com.iishanto.money_controller",
            "certificate_hash": "YOUR_SHA1_HASH"
          }
        }
      ],
      ...
    }
  ]
}
```

---

## 📱 How to Use

### **First Time Setup**

1. **Open Settings**
   - Tap menu (☰) → Settings

2. **Sign in with Google**
   - In "Backup & Restore" section
   - Tap "Sign in with Google"
   - Choose your Google account
   - Grant permissions

3. **Upload First Backup**
   - Tap "Upload Backup"
   - Wait for success message
   - See "Last Backup" timestamp

### **Regular Backup**

1. Go to Settings
2. Tap "Upload Backup"
3. Done! ✅

### **Restore Data**

1. Install app on new device (or after reinstall)
2. Go to Settings
3. Sign in with same Google account
4. Tap "Download Backup"
5. Confirm warning
6. Wait for restore
7. App reloads with all data! ✅

### **Switch Account**

1. Settings → Tap account menu (⋮)
2. Select "Switch Account"
3. Choose different Google account

### **Sign Out**

1. Settings → Tap account menu (⋮)
2. Select "Sign Out"

---

## 🔐 Security & Privacy

### Data Storage
- All backups stored in Google Drive's `appDataFolder`
- This folder is:
  - ✅ Private to your app only
  - ✅ Not visible in Google Drive UI
  - ✅ Not accessible by other apps
  - ✅ Automatically deleted if app is uninstalled

### Authentication
- OAuth 2.0 standard
- No passwords stored in app
- Google manages authentication
- Revocable from Google account settings

### Permissions Required
- `Google Drive API` - For file storage
- Scope: `drive.appdata` - Limited to app data folder only
- Scope: `drive.file` - For file operations

---

## 📊 Backup Data Structure

```json
{
  "backup_version": "1.0",
  "backup_date": "2025-10-31T10:30:00.000Z",
  "app_version": "1.2.0",
  "total_money": 10000.0,
  "fixed_costs": [...],
  "expenses": [...],
  "vault_data": {...},
  "settings": {...},
  "saving_goal": {...},
  "expense_goals": [...]
}
```

---

## ⚠️ Important Notes

### Backup Frequency
- **Manual only** - You control when to backup
- Recommended: Backup after major changes
- Backup before uninstalling app
- Backup weekly for safety

### Data Replacement
- Restore **replaces all current data**
- No merge - complete replacement
- Future: We can add selective merge/date-based merge

### One Backup Per Account
- Only latest backup is kept
- Uploading new backup overwrites old one
- Keep one backup per Google account

### Network Required
- Backup/Restore needs internet connection
- Use WiFi for faster upload/download
- No offline backup support

---

## 🐛 Troubleshooting

### "Sign in failed"
**Solution:**
1. Check internet connection
2. Verify SHA-1 is added to Google Console
3. Ensure OAuth client is created
4. Re-download google-services.json

### "No backup found"
**Cause:** Never uploaded backup with this account
**Solution:** Upload backup first

### "Upload failed"
**Possible causes:**
1. No internet connection
2. Google Drive API not enabled
3. Insufficient Google Drive storage
4. OAuth permissions not granted

**Solution:**
1. Check internet
2. Enable Google Drive API in console
3. Check Google Drive storage
4. Sign out and sign in again

### "Download failed"
**Possible causes:**
1. Backup file corrupted
2. No internet connection
3. OAuth token expired

**Solution:**
1. Upload fresh backup
2. Check internet
3. Sign out and sign in again

---

## 🔄 Migration & Future Plans

### Version 1.2.0 (Current)
- ✅ Manual backup/restore
- ✅ Complete data replacement
- ✅ Google Drive integration
- ✅ Account switching

### Future Enhancements (Planned)
- 🔲 Automatic scheduled backups
- 🔲 Multiple backup versions (keep last 5)
- 🔲 Selective restore (choose what to restore)
- 🔲 Date-based merging
- 🔲 Backup to other cloud services
- 🔲 Local backup option
- 🔲 Export to Excel/CSV
- 🔲 Backup encryption option

---

## 📋 Checklist for Deployment

Before releasing to users:

- [ ] SHA-1 certificate added to Google Cloud Console
- [ ] OAuth client created and configured
- [ ] Google Drive API enabled
- [ ] Updated google-services.json in project
- [ ] Tested on real device (not emulator)
- [ ] Tested backup creation
- [ ] Tested restore functionality
- [ ] Tested account switching
- [ ] Verified data integrity after restore
- [ ] Tested with no internet (shows proper errors)

---

## 💻 Technical Details

### Dependencies Added
```yaml
google_sign_in: ^6.2.1
extension_google_sign_in_as_googleapis_auth: ^2.0.12
googleapis: ^15.0.0
googleapis_auth: ^2.0.0
path_provider: ^2.1.4
http: ^1.2.2
```

### Files Created/Modified
1. **New:** `/lib/core/services/google_drive_service.dart`
2. **Modified:** `/lib/views/settings/settings_page.dart`
3. **Modified:** `/lib/core/constants/strings.dart`
4. **Modified:** `/pubspec.yaml`
5. **Modified:** `/android/app/src/main/AndroidManifest.xml`

### Permissions Added
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## 📞 Support

If users face issues:
1. Check setup guide above
2. Verify Google Cloud Console configuration
3. Test SHA-1 certificate fingerprint
4. Ensure all APIs are enabled
5. Check app permissions in device settings

---

**Status:** ✅ Ready for testing (after OAuth setup)
**Version:** 1.2.0
**Date:** October 31, 2025

