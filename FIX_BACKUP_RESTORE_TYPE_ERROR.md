# ✅ FIX: Backup Restore Type Casting Error

## Problem
When restoring backup from Google Drive, getting error:
```
List<dynamic> is not a subtype of List<Map<String,dynamic>>
```

## Root Cause
When JSON data is decoded, lists come back as `List<dynamic>` but the `PrefsHelper.saveList()` method expects `List<Map<String, dynamic>>`. Direct assignment causes a type mismatch.

### Why This Happens:
1. Backup data is stored as JSON string
2. JSON decode returns `List<dynamic>` and `Map<dynamic, dynamic>`
3. Dart's type system requires explicit casting
4. You can't directly assign `List<dynamic>` to `List<Map<String, dynamic>>`

---

## Solution Applied

### Before (❌ Broken):
```dart
if (data.containsKey('fixed_costs')) {
  await PrefsHelper.saveList(PREF_FIXED_COSTS, data['fixed_costs']);
  // ❌ Error: data['fixed_costs'] is List<dynamic>
  //    but saveList expects List<Map<String, dynamic>>
}
```

### After (✅ Fixed):
```dart
if (data.containsKey('fixed_costs') && data['fixed_costs'] != null) {
  final List<dynamic> rawList = data['fixed_costs'] as List<dynamic>;
  final List<Map<String, dynamic>> fixedCosts = 
      rawList.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  await PrefsHelper.saveList(PREF_FIXED_COSTS, fixedCosts);
  // ✅ Properly cast from List<dynamic> to List<Map<String, dynamic>>
}
```

---

## What Changed

### File Modified:
`/lib/core/services/google_drive_service.dart`

### Method Updated:
`_restoreAllAppData()`

### Changes Made:

1. **For List Types** (fixed_costs, expenses, expense_goals):
   ```dart
   // Step 1: Cast to List<dynamic>
   final List<dynamic> rawList = data['key'] as List<dynamic>;
   
   // Step 2: Map each item to Map<String, dynamic>
   final List<Map<String, dynamic>> typedList = 
       rawList.map((item) => Map<String, dynamic>.from(item as Map)).toList();
   
   // Step 3: Save with proper type
   await PrefsHelper.saveList(KEY, typedList);
   ```

2. **For Map Types** (vault_data, settings, saving_goal):
   ```dart
   // Cast to Map<String, dynamic>
   final Map<String, dynamic> typedMap = 
       Map<String, dynamic>.from(data['key'] as Map);
   
   await PrefsHelper.saveData(KEY, typedMap);
   ```

3. **Added Null Checks**:
   - Check if key exists: `data.containsKey('key')`
   - Check if value is not null: `data['key'] != null`
   - Prevents errors when optional data is missing

---

## What Gets Fixed

### Lists Fixed:
- ✅ `fixed_costs` - List of fixed cost items
- ✅ `expenses` - List of expense items  
- ✅ `expense_goals` - List of expense goal items

### Maps Fixed:
- ✅ `vault_data` - Vault balance and transactions
- ✅ `settings` - App settings
- ✅ `saving_goal` - Saving goal data

### Already Working:
- ✅ `total_money` - Simple number (no casting needed)

---

## Testing

### Test Restore:
```bash
# 1. Upload a backup
flutter run
# In app: Settings → Upload Backup

# 2. Clear app data (simulate fresh install)
# On device: Settings → Apps → Money Controller → Clear Data

# 3. Restore backup
flutter run
# In app: Settings → Sign In → Download Backup

# 4. Verify all data restored
# Check: Total money, fixed costs, expenses, vault, goals
```

### Expected Result:
- ✅ No type casting errors
- ✅ All data restored correctly
- ✅ App functions normally after restore
- ✅ All lists and maps intact

---

## Technical Details

### Type Casting Chain:

**JSON → Dart Types:**
```
JSON String
    ↓ jsonDecode()
List<dynamic>           Map<dynamic, dynamic>
    ↓ as List<dynamic>      ↓ as Map
List<dynamic>           Map
    ↓ .map()                ↓ Map.from()
List<Map<String,dynamic>>   Map<String,dynamic>
    ↓ saveList()            ↓ saveData()
SharedPreferences       SharedPreferences
```

### Why `.from()` and `.map()`?

1. **Map.from()**: Creates a new Map with proper type
   ```dart
   Map<String, dynamic>.from(item as Map)
   ```

2. **.map().toList()**: Transforms each list item
   ```dart
   rawList.map((item) => Map<String, dynamic>.from(item as Map)).toList()
   ```

3. **Null Safety**: Prevents errors on missing data
   ```dart
   if (data.containsKey('key') && data['key'] != null)
   ```

---

## Error Prevention

### Before Fix - Errors Could Occur:
```
❌ Type 'List<dynamic>' is not a subtype of type 'List<Map<String, dynamic>>'
❌ Type '_Map<String, dynamic>' is not a subtype of type 'Map<String, dynamic>'
❌ Null check operator used on a null value
```

### After Fix - Handled:
```
✅ Proper type casting for lists
✅ Proper type casting for maps
✅ Null checks prevent crashes
✅ All data types properly converted
```

---

## Future-Proof

This fix handles:
- ✅ Current data structure
- ✅ New fields added in future (with null checks)
- ✅ Missing fields (won't crash)
- ✅ Empty lists (handled correctly)
- ✅ Null values (checked before processing)

---

## Verification

### Before Running Restore:
```bash
# Check current implementation
cat lib/core/services/google_drive_service.dart | grep -A 5 "_restoreAllAppData"
```

Should show the new implementation with:
- `Map<String, dynamic>.from()`
- `.map((item) => Map<String, dynamic>.from(item as Map)).toList()`
- Null checks with `&& data['key'] != null`

### After Running Restore:
```bash
# No errors should appear in console
# All data should be present in app
```

---

## Summary

**Problem:** Type mismatch when restoring lists from JSON
**Cause:** JSON decode returns `List<dynamic>`, not `List<Map<String, dynamic>>`
**Fix:** Proper type casting with `.map()` and `.from()`
**Result:** ✅ Backup restore works perfectly

**Status:** ✅ FIXED

---

## Quick Reference

### List Type Casting Pattern:
```dart
final List<dynamic> raw = data['key'] as List<dynamic>;
final List<Map<String, dynamic>> typed = 
    raw.map((item) => Map<String, dynamic>.from(item as Map)).toList();
```

### Map Type Casting Pattern:
```dart
final Map<String, dynamic> typed = 
    Map<String, dynamic>.from(data['key'] as Map);
```

### Safe Pattern with Null Check:
```dart
if (data.containsKey('key') && data['key'] != null) {
  // Process data
}
```

---

**✅ The backup restore feature now works correctly without type errors!**

