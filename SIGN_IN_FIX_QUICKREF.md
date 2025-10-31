# 🚨 QUICK FIX: Sign-In Failed Error

## The Problem
✅ You can select Google account  
❌ Then get `sign_in_failed` error

## The Cause
Your `google-services.json` has empty `oauth_client` array.

## The Solution
Configure OAuth client in Google Cloud Console with your SHA-1.

---

## 🎯 Your Information

**SHA-1 Certificate:**
```
BA:2C:2A:1A:C4:80:90:E4:4A:06:BB:5C:8E:CC:6D:22:EC:2D:B0:C7
```

**Package Name:**
```
com.iishanto.money_controller
```

**Project ID:**
```
money-controller-c5eee
```

---

## ⚡ Quick Steps (5 Minutes)

### 1. Open Google Cloud Console
🔗 https://console.cloud.google.com/

### 2. Select Your Project
Click: `money-controller-c5eee`

### 3. Enable APIs
- Go to: `APIs & Services` → `Library`
- Search: **Google Drive API** → Click `ENABLE`
- Search: **Google Sign-In API** → Click `ENABLE` (if not already)

### 4. Create OAuth Client

**A. Go to Credentials:**
`APIs & Services` → `Credentials` → `+ CREATE CREDENTIALS` → `OAuth client ID`

**B. If OAuth Consent Screen not configured:**
- Click `CONFIGURE CONSENT SCREEN`
- User Type: `External` → `CREATE`
- Fill in:
  - App name: `Money Controller`
  - User support email: Your email
  - Developer contact: Your email
- Click `SAVE AND CONTINUE`
- Scopes: Click `ADD OR REMOVE SCOPES`
  - Add: `.../auth/drive.appdata`
  - Add: `.../auth/drive.file`
  - Click `UPDATE` → `SAVE AND CONTINUE`
- Test users: Click `ADD USERS` → Add your Google account email
- Click `SAVE AND CONTINUE` → `BACK TO DASHBOARD`

**C. Create Android OAuth Client:**
Back to: `Credentials` → `+ CREATE CREDENTIALS` → `OAuth client ID`
- Application type: `Android`
- Name: `Money Controller Android Client`
- Package name: 
  ```
  com.iishanto.money_controller
  ```
- SHA-1 certificate fingerprint:
  ```
  BA:2C:2A:1A:C4:80:90:E4:4A:06:BB:5C:8E:CC:6D:22:EC:2D:B0:C7
  ```
- Click: `CREATE`

### 5. Download Updated Config

**After creating OAuth client:**
- Option 1: Google may show a download button immediately
- Option 2: Go to project settings and download

**To download from project settings:**
- Click the hamburger menu (☰)
- Go to: `IAM & Admin` → `Settings`
- Or use Firebase Console: https://console.firebase.google.com/
- Select: `money-controller-c5eee`
- Click gear icon → `Project settings`
- Scroll to "Your apps" → Android app
- Click: Download `google-services.json`

### 6. Replace File

```bash
# Backup old file (optional)
cp android/app/google-services.json android/app/google-services.json.backup

# Replace with new file
# Download the new google-services.json from console
# Move it to: android/app/google-services.json
```

### 7. Rebuild App

```bash
cd /home/bs01595/Downloads/money_controller
flutter clean
flutter pub get
flutter run
```

### 8. Test Sign-In

- Open app → Settings
- Tap "Sign in with Google"
- Select account
- Should work now! ✅

---

## ✅ Verification

After replacing `google-services.json`, check it:

```bash
cat android/app/google-services.json | grep -A 5 "oauth_client"
```

Should show something like:
```json
"oauth_client": [
  {
    "client_id": "123456789.apps.googleusercontent.com",
    "client_type": 1,
    ...
  }
]
```

NOT empty like:
```json
"oauth_client": [],
```

---

## 🔧 Still Not Working?

### Check 1: OAuth Consent Screen Status
- Must be "Testing" or "Published"
- Your email must be added as test user

### Check 2: Correct SHA-1
- Run: `./setup_oauth.sh` to verify
- Must match exactly

### Check 3: Package Name
- Must be: `com.iishanto.money_controller`
- Check in `android/app/build.gradle.kts`

### Check 4: Downloaded After Creation
- Must download google-services.json AFTER creating OAuth client
- Download from correct project

### Check 5: File Location
- Must be: `android/app/google-services.json`
- Not in `android/` root folder

### Check 6: Clean Rebuild
```bash
flutter clean
flutter pub get
rm -rf build/
flutter run
```

---

## 📱 Alternative: Firebase Console

If Google Cloud Console is confusing:

1. Go to: https://console.firebase.google.com/
2. Select: `money-controller-c5eee`
3. Click gear icon → `Project settings`
4. Add Android app SHA-1 there
5. Enable Google Sign-In in `Authentication` → `Sign-in method`
6. Download `google-services.json`

---

## 🆘 Common Mistakes

❌ **Using wrong SHA-1** → Use debug SHA-1 shown above  
❌ **Wrong package name** → Must match exactly  
❌ **Didn't download after OAuth creation** → Must download AFTER  
❌ **OAuth consent screen not configured** → Must configure first  
❌ **Test user not added** → Add your email  
❌ **Wrong file location** → Must be in `android/app/`  
❌ **Didn't clean rebuild** → Always clean after config change  

---

## 📊 What Should Happen

### Before Fix:
1. Tap "Sign in with Google" ✅
2. Select account ✅
3. Get error: `sign_in_failed` ❌

### After Fix:
1. Tap "Sign in with Google" ✅
2. Select account ✅
3. Grant permissions ✅
4. Signed in successfully! ✅
5. Can upload/download backups ✅

---

## 🎯 Bottom Line

**You need to:**
1. Create OAuth client in Google Cloud Console
2. Use YOUR SHA-1: `BA:2C:2A:1A:C4:80:90:E4:4A:06:BB:5C:8E:CC:6D:22:EC:2D:B0:C7`
3. Use correct package: `com.iishanto.money_controller`
4. Download updated `google-services.json`
5. Replace file in `android/app/`
6. Clean rebuild

**That's it!** The sign-in will work after this. 🎉

---

## 📖 More Help

- **Detailed Guide:** `FIX_SIGN_IN_FAILED.md`
- **Run Helper Script:** `./setup_oauth.sh`
- **Full Documentation:** `GOOGLE_DRIVE_BACKUP_GUIDE.md`

---

**🚀 Ready? Follow the steps above and you'll be backing up to Google Drive in 5 minutes!**

