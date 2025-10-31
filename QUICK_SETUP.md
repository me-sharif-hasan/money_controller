# Quick Setup Instructions - Google Drive Backup

## ⚡ Quick Start (5 minutes)

### Step 1: Get SHA-1 Fingerprint
```bash
cd /home/bs01595/Downloads/money_controller/android
./gradlew signingReport
```
Look for output like:
```
Variant: debug
SHA1: AA:BB:CC:DD:EE:FF:...
```
**Copy this SHA-1 value**

---

### Step 2: Configure Google Cloud Console

1. **Open**: https://console.cloud.google.com/
2. **Select project**: `money-controller-c5eee`

3. **Enable APIs**:
   - Go to: `APIs & Services` → `Library`
   - Search and enable: `Google Drive API`
   - Search and enable: `Google Sign-In API` (if needed)

4. **Create OAuth Client**:
   - Go to: `APIs & Services` → `Credentials`
   - Click: `+ CREATE CREDENTIALS` → `OAuth client ID`
   - Choose: `Android`
   - Package name: `com.iishanto.money_controller`
   - SHA-1: Paste the value from Step 1
   - Click: `CREATE`

5. **Download updated config**:
   - Click on your new OAuth client
   - Download the updated `google-services.json`
   - Replace: `/home/bs01595/Downloads/money_controller/android/app/google-services.json`

---

### Step 3: Test the Feature

1. Build and run the app:
   ```bash
   cd /home/bs01595/Downloads/money_controller
   flutter run
   ```

2. In the app:
   - Open Settings
   - Tap "Sign in with Google"
   - Choose your account
   - Tap "Upload Backup"
   - Success! ✅

---

## ✅ Verification Checklist

- [ ] SHA-1 obtained from gradle
- [ ] Google Drive API enabled
- [ ] OAuth client created with correct SHA-1
- [ ] Updated google-services.json downloaded
- [ ] File replaced in android/app/
- [ ] App builds without errors
- [ ] Can sign in with Google
- [ ] Can upload backup
- [ ] Can see "Last Backup" timestamp
- [ ] Can download backup

---

## 🎯 Current Status

### ✅ Completed
- Google Drive service implementation
- Settings page UI
- Sign in/out/switch account
- Upload backup functionality
- Download backup functionality
- Backup info display
- Data serialization/deserialization
- All providers integration
- Error handling

### ⚠️ Requires Manual Setup
- SHA-1 certificate in Google Cloud Console
- OAuth client configuration
- Updated google-services.json

### 🧪 Testing Required
- Test on real device (emulator may not work for Google Sign-In)
- Test backup creation
- Test restore on clean install
- Test account switching

---

## 🚀 Quick Commands

### Get SHA-1:
```bash
cd android && ./gradlew signingReport | grep SHA1
```

### Clean build:
```bash
flutter clean && flutter pub get
```

### Build APK:
```bash
flutter build apk
```

### Run on device:
```bash
flutter run
```

---

## 📝 Notes

- **First time setup**: Need to configure OAuth in Google Cloud Console
- **Testing**: Use real device, emulator may have issues with Google Sign-In
- **Backup storage**: Uses appDataFolder (private to app)
- **Data safety**: Always test restore before relying on it
- **Internet required**: Both backup and restore need active internet

---

## 🆘 Common Issues

### "Sign in failed"
→ Check SHA-1 in Google Console

### "Upload failed" 
→ Check Drive API is enabled

### "No backup found"
→ Upload backup first from same account

### Build errors
→ Run `flutter clean && flutter pub get`

---

**Ready to test!** 🎉

Once OAuth is configured, the feature is fully functional.

