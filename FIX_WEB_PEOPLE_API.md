# 🔧 FIX: People API Not Enabled (Web Sign-In Error)

## Problem
**Platform:** Web (works fine on Android)  
**Error:** 
```
ClientException: {
  "error": {
    "code": 403,
    "message": "People API has not been used in project 321117363173 before or it is disabled.",
    "status": "PERMISSION_DENIED"
  }
}
```

## Why This Happens

### Android vs Web:
- **Android:** Uses native Google Sign-In (doesn't need People API)
- **Web:** Uses Google Sign-In for Web (requires People API to fetch profile)

### What People API Does:
- Fetches user profile information (name, email, photo)
- Required for web-based Google Sign-In
- Not required for native Android sign-in

---

## ✅ Quick Fix (2 Minutes)

### Step 1: Enable People API

**Option A - Direct Link:**
Click this link and enable:
```
https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=321117363173
```
Then click the **"ENABLE"** button.

**Option B - Manual Navigation:**
1. Go to: https://console.cloud.google.com/
2. Select project: `money-controller-c5eee`
3. Go to: `APIs & Services` → `Library`
4. Search: `People API`
5. Click on `People API`
6. Click: **"ENABLE"**

### Step 2: Wait
- Wait 2-5 minutes for changes to propagate
- Google's systems need time to activate the API

### Step 3: Test
```bash
flutter run -d chrome
# Or your web browser
```
- Go to Settings
- Try "Sign in with Google" again
- Should work now! ✅

---

## Detailed Steps with Screenshots Guide

### 1. Open Google Cloud Console
🔗 https://console.cloud.google.com/

### 2. Select Your Project
- Click project dropdown at top
- Select: **money-controller-c5eee**

### 3. Navigate to APIs & Services
- Click hamburger menu (☰)
- Click: **APIs & Services**
- Click: **Library**

### 4. Find People API
- In search box, type: `People API`
- Click on: **Google People API**

### 5. Enable the API
- You'll see a blue **"ENABLE"** button
- Click it
- Wait for confirmation message

### 6. Verify
- Status should show: **"API enabled"**
- You may see usage statistics (will be 0 initially)

### 7. Test Sign-In
- Run your web app
- Try sign-in again
- Should work without 403 error

---

## What APIs Are Needed?

### For Android:
- ✅ Google Drive API (for backup)
- ✅ OAuth 2.0 Client (Android)

### For Web:
- ✅ Google Drive API (for backup)
- ✅ OAuth 2.0 Client (Web)
- ✅ **People API** ← This was missing!

---

## Why Wasn't This Needed Before?

The People API is specifically for web authentication. When you test on Android:
- Uses native Google Play Services
- Directly accesses profile through device APIs
- Doesn't make HTTP calls to People API

When you test on web:
- Uses Google Sign-In for Web library
- Makes HTTP calls to fetch user profile
- Requires People API to be enabled

---

## Verification

After enabling, verify these are all enabled:

```bash
# Go to: APIs & Services → Dashboard
# Should see:
✅ Google Drive API - Enabled
✅ People API - Enabled
```

---

## Common Issues

### "Still getting 403 error"
**Solution:** Wait 5 more minutes, API activation can be slow

### "Enable button is grayed out"
**Solution:** Check you have proper permissions on the project

### "Can't find People API"
**Solution:** Make sure you're searching in the Library section

### "Works in incognito but not regular browser"
**Solution:** Clear browser cache and cookies

---

## Testing Checklist

After enabling People API:

- [ ] Wait 5 minutes after enabling
- [ ] Clear browser cache
- [ ] Run flutter app in web mode
- [ ] Try sign-in
- [ ] Should see Google account picker
- [ ] Should successfully sign in
- [ ] Should show "Signed in as [email]"
- [ ] Upload backup should work
- [ ] Download backup should work

---

## Platform-Specific Setup Summary

### Android Setup:
```
✅ OAuth Client (Android) with SHA-1
✅ Google Drive API enabled
✅ google-services.json configured
```

### Web Setup:
```
✅ OAuth Client (Web) 
✅ Google Drive API enabled
✅ People API enabled ← YOU ARE HERE
✅ Authorized JavaScript origins set
✅ Authorized redirect URIs set
```

---

## Web OAuth Client Configuration

While you're in Google Cloud Console, also verify Web OAuth client:

### Check Web OAuth Client:
1. Go to: `APIs & Services` → `Credentials`
2. Find your Web OAuth client
3. Verify:
   - **Authorized JavaScript origins:**
     ```
     http://localhost
     http://localhost:8080
     http://localhost:3000
     ```
   - **Authorized redirect URIs:**
     ```
     http://localhost
     http://localhost:8080
     http://localhost:3000
     ```

### If Web OAuth Client Doesn't Exist:
1. Click: `CREATE CREDENTIALS` → `OAuth client ID`
2. Application type: **Web application**
3. Name: `Money Controller Web`
4. Add JavaScript origins (listed above)
5. Add redirect URIs (listed above)
6. Click: `CREATE`

---

## Quick Commands

### Run on Web:
```bash
# Chrome
flutter run -d chrome

# Edge
flutter run -d edge

# Any available
flutter run -d web-server
```

### Check Running Devices:
```bash
flutter devices
```

### Build for Web:
```bash
flutter build web
```

---

## Error Messages Explained

### 403 PERMISSION_DENIED
```
❌ People API not enabled
✅ Fix: Enable People API
```

### 401 UNAUTHORIZED
```
❌ OAuth not configured
✅ Fix: Create Web OAuth client
```

### CORS Error
```
❌ JavaScript origins not set
✅ Fix: Add localhost to authorized origins
```

### Redirect URI Mismatch
```
❌ Redirect URI not authorized
✅ Fix: Add redirect URI to OAuth client
```

---

## What's Different in Web vs Android

| Feature | Android | Web |
|---------|---------|-----|
| Sign-In Library | google_sign_in (native) | google_sign_in (web) |
| OAuth Client | Android type | Web type |
| Certificate | SHA-1 required | Not needed |
| JavaScript Origins | Not needed | Required |
| Redirect URIs | Not needed | Required |
| People API | Not needed | **Required** ✅ |

---

## Testing on Different Platforms

### Test on Android:
```bash
flutter run
# Uses Android OAuth + native sign-in
# People API not needed
```

### Test on Web:
```bash
flutter run -d chrome
# Uses Web OAuth + People API
# People API required ✅
```

### Test on iOS:
```bash
flutter run -d ios
# Uses iOS native sign-in
# People API not needed
```

---

## Summary

**Problem:** People API not enabled  
**Platform:** Web only (Android works fine)  
**Solution:** Enable People API in Google Cloud Console  
**Time:** 2 minutes + 5 minute wait  
**Difficulty:** Easy  

**Steps:**
1. Enable People API
2. Wait 5 minutes
3. Test sign-in
4. ✅ Works!

---

## Quick Links

- **Enable People API:** https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=321117363173
- **Google Cloud Console:** https://console.cloud.google.com/
- **APIs Dashboard:** https://console.cloud.google.com/apis/dashboard?project=money-controller-c5eee

---

## Status After Fix

### Before:
- ✅ Android sign-in works
- ❌ Web sign-in fails (403)

### After:
- ✅ Android sign-in works
- ✅ Web sign-in works
- ✅ All platforms functional

---

**🎯 Bottom Line:**

Enable the People API in Google Cloud Console and wait 5 minutes. That's it!

**Direct link:** https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=321117363173

Click **"ENABLE"** and you're done! 🚀

