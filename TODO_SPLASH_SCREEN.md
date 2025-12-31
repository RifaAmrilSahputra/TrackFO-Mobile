# Splash Screen Implementation Plan

## Status: ✅ Completed

### Tasks:
- [x] 1. Add `validateToken()` method in AuthService
- [x] 2. Update AuthProvider with `validateAndRefresh()` method
- [x] 3. Enhance SplashScreen with better UI and validation logic
- [x] 4. Update AuthGate to use the new validation

### Additional Tasks (Logout Dialog Refactoring):
- [x] 5. Extract logout dialog to reusable component
- [x] 6. Update admin_setting_page to use LogoutDialog
- [x] 7. Update teknisi_akun_page to use LogoutDialog

---

## Implementation Details:

### Step 1: AuthService - Add validateToken() ✅
Added `validateToken()` method that calls `/auth/me` endpoint to verify token validity.

### Step 2: AuthProvider - Add validateAndRefresh() ✅
Added `validateAndRefresh()` method that:
- Checks if token exists
- Validates with backend
- Logs out if token is invalid

### Step 3: SplashScreen - Minimalist Design ✅
- Clean design matching login page theme
- Logo with indigo background
- App name "TrackFO" with tagline
- Loading indicator with status text
- 1.5 second minimum duration

### Step 4: AuthGate - Integration ✅
Updated comments to reflect new flow. Validation happens in SplashScreen.

### Step 5: Logout Dialog Component ✅
Created `lib/features/main/widgets/logout_dialog.dart`:
- Reusable `LogoutDialog` class
- `showForAdmin()` - for admin users
- `showForTeknisi()` - for teknisi users
- Properly sized to avoid overflow

### Step 6 & 7: Updated Pages ✅
Both admin and teknisi pages now use the shared LogoutDialog component.

