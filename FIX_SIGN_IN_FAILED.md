# 🔧 FIX: Google Sign-In Failed Error

## Problem
You can select a Google account but then get `PlatformException: sign_in_failed` error.

## Root Cause
The `oauth_client` array in your `google-services.json` is empty. This means OAuth client hasn't been configured in Google Cloud Console yet.

---

## ✅ Solution: Configure OAuth Client

### Your Debug SHA-1:
```
BA:2C:2A:1A:C4:80:90:E4:4A:06:BB:5C:8E:CC:6D:22:EC:2D:B0:C7
```

### Step-by-Step Fix:

#### 1. Open Google Cloud Console
Go to: https://console.cloud.google.com/

#### 2. Select Your Project
Project: **money-controller-c5eee**

#### 3. Enable Required APIs
- Navigate: `APIs & Services` → `Library`
- Search and Enable:
  - ✅ **Google Drive API**
  - ✅ **Google Sign-In API** (may already be enabled)

#### 4. Create OAuth Client ID

**A. Go to Credentials:**
- Navigate: `APIs & Services` → `Credentials`
- Click: `+ CREATE CREDENTIALS`
- Choose: `OAuth client ID`

**B. Configure OAuth Consent Screen (if prompted):**
- User Type: `External`
- App name: `Money Controller`
- User support email: Your email
- Developer contact: Your email
- Scopes: Add `drive.appdata` and `drive.file`
- Test users: Add your Google account email
- Click: `SAVE AND CONTINUE` through all steps

**C. Create Android OAuth Client:**
- Application type: `Android`
- Name: `Money Controller Android`
- Package name: `com.iishanto.money_controller`
- SHA-1 certificate fingerprint: 
  ```
  BA:2C:2A:1A:C4:80:90:E4:4A:06:BB:5C:8E:CC:6D:22:EC:2D:B0:C7
  ```
- Click: `CREATE`

#### 5. Download Updated Configuration

**Option A - Automatic (Recommended):**
- Google Cloud Console should offer to download updated `google-services.json`
- Download it
- Replace: `/home/bs01595/Downloads/money_controller/android/app/google-services.json`

**Option B - Manual:**
- Go to: `Project Settings` → `General`
- Under "Your apps", find your Android app
- Click: Download `google-services.json`
- Replace the file

#### 6. Create Web OAuth Client (Also Needed)

Sometimes Android OAuth requires a Web client too:

- In Credentials, click: `+ CREATE CREDENTIALS` → `OAuth client ID`
- Application type: `Web application`
- Name: `Money Controller Web`
- Click: `CREATE`

#### 7. Verify and Download Again

After creating both clients, download the `google-services.json` again to ensure it includes both OAuth clients.

---

## 📋 Verification

After replacing `google-services.json`, verify it has OAuth clients:

```bash
cat android/app/google-services.json | grep -A 10 "oauth_client"
```

You should see something like:
```json
"oauth_client": [
  {
    "client_id": "xxx.apps.googleusercontent.com",
    "client_type": 1,
    "android_info": {
      "package_name": "com.iishanto.money_controller",
      "certificate_hash": "ba2c2a1ac48090e44a06bb5c8ecc6d22ec2db0c7"
    }
  }
]
```

---

## 🧪 Test After Fix

1. Clean and rebuild:
   ```bash
   cd /home/bs01595/Downloads/money_controller
   flutter clean
   flutter pub get
   flutter run
   ```

2. In app:
   - Go to Settings
   - Tap "Sign in with Google"
   - Select account
   - Should work now! ✅

---

## 🔍 Troubleshooting

### Still Getting Error?

**Check 1: OAuth Consent Screen**
- Status must be "Published" or "Testing" with your email added
- Scopes must include Drive API

**Check 2: SHA-1 Certificate**
- Must match exactly (case-insensitive)
- Use debug SHA-1 for development
- Use release SHA-1 for production

**Check 3: Package Name**
- Must be: `com.iishanto.money_controller`
- Check in: `android/app/build.gradle.kts`

**Check 4: google-services.json**
- Must be in: `android/app/`
- Must have oauth_client array filled
- Not empty

**Check 5: App Registration**
- App must be registered in Firebase/Google Cloud
- Configuration must be downloaded after OAuth creation

### Common Mistakes:
❌ Using wrong SHA-1 (release instead of debug)
❌ Wrong package name
❌ OAuth client not created
❌ Not downloading updated google-services.json
❌ OAuth consent screen not configured
❌ Test user not added (for testing mode)

---

## 🚀 Quick Fix Commands

```bash
# 1. Get your SHA-1 (already done)
cd android && ./gradlew signingReport | grep SHA1

# Output: BA:2C:2A:1A:C4:80:90:E4:4A:06:BB:5C:8E:CC:6D:22:EC:2D:B0:C7

# 2. After updating google-services.json, clean rebuild
cd ..
flutter clean
flutter pub get

# 3. Run app
flutter run
```

---

## 📱 Alternative: Use Firebase Console

If Google Cloud Console is confusing, use Firebase Console:

1. Go to: https://console.firebase.google.com/
2. Select project: `money-controller-c5eee`
3. Click: Settings (gear icon) → Project settings
4. Scroll to: "Your apps"
5. Under Android app, click: Download `google-services.json`
6. But first, make sure to:
   - Add SHA-1 in Firebase project settings
   - Enable Google Sign-In in Authentication

---

## ✅ Expected Result After Fix

```
✅ oauth_client array populated
✅ Sign in works
✅ Can upload backup
✅ Can download backup
✅ No more sign_in_failed error
```

---

## 📝 Summary

**Issue:** Empty `oauth_client` in google-services.json
**Fix:** Create OAuth client in Google Cloud Console with your SHA-1
**SHA-1:** BA:2C:2A:1A:C4:80:90:E4:4A:06:BB:5C:8E:CC:6D:22:EC:2D:B0:C7
**Package:** com.iishanto.money_controller

Follow the steps above, download updated google-services.json, rebuild, and it should work!

---

**Need Help?** The most common issue is forgetting to download the updated google-services.json after creating the OAuth client. Make sure you download it AFTER creating the OAuth client!

