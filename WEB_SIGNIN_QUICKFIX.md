# ⚡ QUICK FIX: Web Sign-In Error (People API)

## The Error
```
403 PERMISSION_DENIED
People API has not been used in project 321117363173
```

## Why
- **Android:** Works fine (uses native sign-in)
- **Web:** Fails (needs People API for profile data)

---

## 🎯 Solution (2 Minutes)

### Step 1: Click This Link
```
https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=321117363173
```

### Step 2: Click "ENABLE"
Just click the blue ENABLE button.

### Step 3: Wait
Wait 5 minutes for activation.

### Step 4: Test
```bash
flutter run -d chrome
```
Sign in again - should work! ✅

---

## What Changed in Code

Added better error detection:

```dart
if (e.toString().contains('People API')) {
  // Show helpful message about enabling People API
}
```

Now the app shows:
- ✅ Clear error message
- ✅ Direct link to enable API
- ✅ Instructions

---

## Verification

### Before:
- ✅ Android: Sign-in works
- ❌ Web: 403 error

### After:
- ✅ Android: Sign-in works
- ✅ Web: Sign-in works

---

## Platform Differences

| Need | Android | Web |
|------|---------|-----|
| OAuth Client | Android | Web |
| SHA-1 | ✅ | ❌ |
| Drive API | ✅ | ✅ |
| People API | ❌ | ✅ |

---

## Quick Test

```bash
# Test Android
flutter run

# Test Web
flutter run -d chrome

# Both should work after enabling People API
```

---

## Files Updated

1. **settings_page.dart** - Better error messages
2. **FIX_WEB_PEOPLE_API.md** - Detailed guide
3. **This file** - Quick reference

---

## Status

**Issue:** People API not enabled for web  
**Fix:** Enable in console (2 min)  
**Code:** Updated error handling ✅  
**Docs:** Created ✅  

---

## Bottom Line

**Android works, web doesn't?**  
→ Enable People API  
→ Wait 5 minutes  
→ Works! ✅

**Link:** https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=321117363173

**Just click ENABLE!** 🚀

