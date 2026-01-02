# 🔐 Google Sign-In Setup Guide for PawSewa

## 🎯 **Overview**

This guide will help you set up Google Sign-In for your PawSewa Flutter app, allowing users to sign in with their Google accounts seamlessly.

## ✅ **What's Already Done**

- ✅ Firebase project setup
- ✅ `google-services.json` configured
- ✅ Firebase Auth dependencies added
- ✅ Google Sign-In dependency added to `pubspec.yaml`
- ✅ AuthService enhanced with Google Sign-In methods
- ✅ Login/Signup screens updated with functional Google buttons
- ✅ AuthLayout updated to handle Google users
- ✅ Test screen created for debugging

## 🛠️ **Firebase Console Setup**

### **Step 1: Enable Google Sign-In**

1. **Go to Firebase Console**
   - Visit [Firebase Console](https://console.firebase.google.com/)
   - Select your project: `pawsewa-25997`

2. **Navigate to Authentication**
   - Click "Authentication" in the left sidebar
   - Click "Sign-in method" tab

3. **Enable Google Sign-In**
   - Find "Google" in the list of providers
   - Click on it and toggle "Enable"
   - Set your project support email
   - Click "Save"

### **Step 2: Configure OAuth Consent Screen**

1. **Go to Google Cloud Console**
   - Visit [Google Cloud Console](https://console.cloud.google.com/)
   - Select your project: `pawsewa-25997`

2. **Configure OAuth Consent Screen**
   - Go to "APIs & Services" → "OAuth consent screen"
   - Choose "External" user type
   - Fill in required information:
     - App name: `PawSewa`
     - User support email: `support@pawsewa.com`
     - Developer contact: `your-email@domain.com`

3. **Add Scopes**
   - Add these scopes:
     - `../auth/userinfo.email`
     - `../auth/userinfo.profile`
     - `openid`

## 📱 **Android Configuration**

### **Step 1: Get SHA-1 Certificate Fingerprint**

#### **For Debug (Development):**
```bash
# Windows
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android

# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

#### **For Release (Production):**
```bash
# Replace with your keystore path
keytool -list -v -keystore path/to/your/release-keystore.jks -alias your-key-alias
```

### **Step 2: Add SHA-1 to Firebase**

1. **Go to Firebase Console**
   - Project Settings → General tab
   - Scroll down to "Your apps" section
   - Click on your Android app

2. **Add SHA-1 Fingerprints**
   - Click "Add fingerprint"
   - Paste your SHA-1 certificate fingerprint
   - Add both debug and release fingerprints
   - Click "Save"

3. **Download Updated google-services.json**
   - Download the updated `google-services.json`
   - Replace the existing file in `android/app/`

### **Step 3: Verify Android Configuration**

Your `android/app/google-services.json` should contain:
```json
{
  "project_info": {
    "project_id": "pawsewa-25997"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:188502859936:android:b491c62f7bb870e71ce9c5",
        "android_client_info": {
          "package_name": "com.example.pawsewa"
        }
      },
      "oauth_client": [
        {
          "client_id": "your-client-id.apps.googleusercontent.com",
          "client_type": 1,
          "android_info": {
            "package_name": "com.example.pawsewa",
            "certificate_hash": "your-sha1-hash"
          }
        }
      ]
    }
  ]
}
```

## 🍎 **iOS Configuration**

### **Step 1: Add GoogleService-Info.plist**

1. **Download from Firebase Console**
   - Go to Project Settings → General
   - Find your iOS app
   - Download `GoogleService-Info.plist`

2. **Add to Xcode Project**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Right-click on "Runner" folder
   - Select "Add Files to Runner"
   - Choose `GoogleService-Info.plist`
   - Make sure "Copy items if needed" is checked
   - Select "Runner" target

### **Step 2: Configure URL Schemes**

1. **Open ios/Runner/Info.plist**
2. **Add URL Scheme**
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLName</key>
       <string>REVERSED_CLIENT_ID</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>YOUR_REVERSED_CLIENT_ID</string>
       </array>
     </dict>
   </array>
   ```

3. **Get REVERSED_CLIENT_ID**
   - Open `GoogleService-Info.plist`
   - Find `REVERSED_CLIENT_ID` value
   - Replace `YOUR_REVERSED_CLIENT_ID` with this value

### **Step 3: Update iOS Bundle ID**

Ensure your iOS Bundle ID matches:
- Firebase Console iOS app configuration
- Xcode project Bundle Identifier
- `GoogleService-Info.plist` BUNDLE_ID

## 🧪 **Testing Google Sign-In**

### **Step 1: Build and Run**

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Run on device/emulator
flutter run
```

### **Step 2: Test Authentication Flow**

1. **Open the app**
2. **Navigate to login screen**
3. **Tap "Continue with Google"**
4. **Complete Google Sign-In flow**
5. **Verify user is signed in**

### **Step 3: Use Debug Screen**

1. **Sign in to the app**
2. **Open drawer menu**
3. **Tap "Google Sign-In Test"**
4. **Test various scenarios:**
   - Sign in with Google
   - Check current user
   - Sign out
   - Monitor authentication state

## 🔍 **Troubleshooting**

### **Common Issues**

#### **"Google Sign-In was cancelled"**
- **Cause**: User cancelled the sign-in flow
- **Solution**: This is normal behavior, no action needed

#### **"PlatformException(sign_in_failed)"**
- **Cause**: SHA-1 fingerprint not configured
- **Solution**: Add SHA-1 fingerprint to Firebase Console

#### **"ApiException: 10"**
- **Cause**: OAuth client not configured properly
- **Solution**: Check `google-services.json` has oauth_client section

#### **iOS: "No such module 'GoogleSignIn'"**
- **Cause**: iOS dependencies not installed
- **Solution**: Run `cd ios && pod install`

#### **"DEVELOPER_ERROR"**
- **Cause**: Package name mismatch
- **Solution**: Ensure package names match in:
  - `android/app/build.gradle`
  - Firebase Console
  - `google-services.json`

### **Debug Steps**

1. **Check Firebase Console**
   - Verify Google Sign-In is enabled
   - Check SHA-1 fingerprints are added
   - Verify package name matches

2. **Check google-services.json**
   - Ensure file is in `android/app/`
   - Verify it contains oauth_client section
   - Check package name matches

3. **Check Dependencies**
   ```bash
   flutter pub deps
   ```

4. **Clean and Rebuild**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 📊 **Testing Checklist**

### **Android Testing**
- [ ] SHA-1 fingerprint added to Firebase
- [ ] `google-services.json` updated and placed correctly
- [ ] Google Sign-In button appears
- [ ] Tapping button opens Google Sign-In flow
- [ ] Sign-in completes successfully
- [ ] User data is retrieved correctly
- [ ] Sign-out works properly

### **iOS Testing**
- [ ] `GoogleService-Info.plist` added to Xcode project
- [ ] URL scheme configured in Info.plist
- [ ] Bundle ID matches Firebase configuration
- [ ] Google Sign-In flow works on iOS device/simulator
- [ ] User authentication persists across app restarts

### **Cross-Platform Testing**
- [ ] Authentication state syncs across platforms
- [ ] User profile data is consistent
- [ ] Sign-out works on both platforms
- [ ] Error handling works properly

## 🚀 **Production Deployment**

### **Release Configuration**

1. **Generate Release SHA-1**
   ```bash
   keytool -list -v -keystore path/to/release-keystore.jks -alias your-alias
   ```

2. **Add Release SHA-1 to Firebase**
   - Add release SHA-1 fingerprint
   - Download updated `google-services.json`

3. **Test Release Build**
   ```bash
   flutter build apk --release
   flutter install --release
   ```

### **App Store/Play Store**

- Ensure OAuth consent screen is configured
- Add privacy policy URL
- Configure app verification if required
- Test with production builds

## ✅ **Success Criteria**

Your Google Sign-In is working correctly when:

- ✅ Google Sign-In button appears in login/signup screens
- ✅ Tapping button opens Google account selection
- ✅ Sign-in completes and returns to app
- ✅ User profile data is retrieved (name, email, photo)
- ✅ Authentication state persists across app restarts
- ✅ Sign-out works and clears authentication
- ✅ Error handling works for cancelled/failed sign-ins
- ✅ Works on both Android and iOS

## 🎉 **Benefits**

✅ **Seamless User Experience** - One-tap sign-in with Google
✅ **No Password Required** - Users don't need to remember passwords
✅ **Trusted Authentication** - Google's secure authentication system
✅ **Rich User Data** - Access to profile name, email, and photo
✅ **Cross-Platform** - Works on both Android and iOS
✅ **Automatic Verification** - Google users don't need email verification

Your Google Sign-In integration is now complete and ready for production! 🚀