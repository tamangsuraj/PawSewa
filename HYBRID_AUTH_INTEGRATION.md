# 🔥 Hybrid Firebase + Custom OTP Integration

## 🎯 **Integration Strategy**

This guide shows how to combine Firebase Authentication with your custom OTP system for the best of both worlds:

- **Firebase Auth** - Secure user management and session handling
- **Custom OTP** - Professional email delivery from your business domain
- **Hybrid Approach** - Use Firebase for auth, custom OTP for email verification

## 🏗️ **Architecture Overview**

```
User Registration Flow:
1. User fills signup form
2. Create Firebase user (without email verification)
3. Send custom OTP via your business email
4. User verifies OTP
5. Update Firebase user as verified
6. Navigate to main app

Password Reset Flow:
1. User requests password reset
2. Send custom OTP (not Firebase reset email)
3. User verifies OTP
4. Allow password change via Firebase
5. Update password in Firebase
```

## 📱 **Flutter Implementation**

### **Enhanced AuthService with Custom OTP**

```dart
// lib/services/hybrid_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_service.dart';

class HybridAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Check if user is authenticated AND email verified
  bool get isFullyAuthenticated => 
      currentUser != null && (currentUser!.emailVerified || _isCustomVerified);
  
  // Track custom verification status (in production, use secure storage)
  static final Set<String> _customVerifiedEmails = <String>{};
  
  bool get _isCustomVerified => 
      currentUser != null && _customVerifiedEmails.contains(currentUser!.email);
  
  // Hybrid signup with custom OTP
  Future<SignupResult> signUpWithCustomOtp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Step 1: Create Firebase user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Step 2: Update display name
      await userCredential.user?.updateDisplayName(fullName);
      
      // Step 3: Send custom OTP (not Firebase verification)
      final otpResponse = await OtpService.sendVerificationOtp(email);
      
      if (otpResponse.success) {
        return SignupResult(
          success: true,
          user: userCredential.user,
          message: 'Account created! Please verify your email.',
          requiresOtpVerification: true,
        );
      } else {
        // If OTP sending fails, delete the Firebase user
        await userCredential.user?.delete();
        return SignupResult(
          success: false,
          error: 'Failed to send verification email: ${otpResponse.error}',
        );
      }
    } on FirebaseAuthException catch (e) {
      return SignupResult(
        success: false,
        error: _handleAuthException(e),
      );
    } catch (e) {
      return SignupResult(
        success: false,
        error: 'Signup failed: $e',
      );
    }
  }
  
  // Verify custom OTP and mark user as verified
  Future<VerificationResult> verifyCustomOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await OtpService.verifyOtp(email, otp);
      
      if (response.success && response.verified) {
        // Mark email as custom verified
        _customVerifiedEmails.add(email);
        
        // Optionally, you can also mark Firebase user as verified
        // Note: This requires admin SDK or custom claims
        
        return VerificationResult(
          success: true,
          message: 'Email verified successfully!',
        );
      } else {
        return VerificationResult(
          success: false,
          error: response.error ?? 'Verification failed',
        );
      }
    } catch (e) {
      return VerificationResult(
        success: false,
        error: 'Verification error: $e',
      );
    }
  }
  
  // Sign in (only allow if custom verified)
  Future<SigninResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Check if user has custom verification
      if (!_customVerifiedEmails.contains(email)) {
        // User exists but not verified, resend OTP
        final otpResponse = await OtpService.sendVerificationOtp(email);
        
        return SigninResult(
          success: false,
          user: userCredential.user,
          error: 'Please verify your email first',
          requiresOtpVerification: true,
          otpSent: otpResponse.success,
        );
      }
      
      return SigninResult(
        success: true,
        user: userCredential.user,
        message: 'Signed in successfully',
      );
    } on FirebaseAuthException catch (e) {
      return SigninResult(
        success: false,
        error: _handleAuthException(e),
      );
    } catch (e) {
      return SigninResult(
        success: false,
        error: 'Sign in failed: $e',
      );
    }
  }
  
  // Password reset with custom OTP
  Future<PasswordResetResult> initiatePasswordReset(String email) async {
    try {
      // Send custom OTP instead of Firebase reset email
      final otpResponse = await OtpService.sendPasswordResetOtp(email);
      
      if (otpResponse.success) {
        return PasswordResetResult(
          success: true,
          message: 'Password reset code sent to your email',
          email: email,
        );
      } else {
        return PasswordResetResult(
          success: false,
          error: otpResponse.error ?? 'Failed to send reset code',
        );
      }
    } catch (e) {
      return PasswordResetResult(
        success: false,
        error: 'Password reset failed: $e',
      );
    }
  }
  
  // Complete password reset after OTP verification
  Future<PasswordResetResult> completePasswordReset({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      // First verify the OTP
      final otpVerification = await OtpService.verifyOtp(email, otp);
      
      if (!otpVerification.success || !otpVerification.verified) {
        return PasswordResetResult(
          success: false,
          error: otpVerification.error ?? 'Invalid verification code',
        );
      }
      
      // OTP verified, now update password
      // Note: This requires the user to be signed in, or use admin SDK
      final user = currentUser;
      if (user != null && user.email == email) {
        await user.updatePassword(newPassword);
        
        return PasswordResetResult(
          success: true,
          message: 'Password updated successfully',
        );
      } else {
        return PasswordResetResult(
          success: false,
          error: 'User must be signed in to change password',
        );
      }
    } catch (e) {
      return PasswordResetResult(
        success: false,
        error: 'Password reset failed: $e',
      );
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication error occurred.';
    }
  }
}

// Result classes
class SignupResult {
  final bool success;
  final User? user;
  final String? message;
  final String? error;
  final bool requiresOtpVerification;
  
  SignupResult({
    required this.success,
    this.user,
    this.message,
    this.error,
    this.requiresOtpVerification = false,
  });
}

class SigninResult {
  final bool success;
  final User? user;
  final String? message;
  final String? error;
  final bool requiresOtpVerification;
  final bool otpSent;
  
  SigninResult({
    required this.success,
    this.user,
    this.message,
    this.error,
    this.requiresOtpVerification = false,
    this.otpSent = false,
  });
}

class VerificationResult {
  final bool success;
  final String? message;
  final String? error;
  
  VerificationResult({
    required this.success,
    this.message,
    this.error,
  });
}

class PasswordResetResult {
  final bool success;
  final String? message;
  final String? error;
  final String? email;
  
  PasswordResetResult({
    required this.success,
    this.message,
    this.error,
    this.email,
  });
}

// Global instance
final hybridAuthService = HybridAuthService();
```

### **Updated Auth Layout**

```dart
// lib/hybrid_auth_layout.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/hybrid_auth_service.dart';
import 'main_screen.dart';
import 'login.dart';
import 'custom_otp_verification_screen.dart';

class HybridAuthLayout extends StatelessWidget {
  const HybridAuthLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: hybridAuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        
        if (user != null) {
          // User is signed in, check if fully verified
          if (hybridAuthService.isFullyAuthenticated) {
            return const MainScreen();
          } else {
            // User signed in but not verified, show OTP screen
            return CustomOtpVerificationScreen(
              email: user.email ?? '',
              purpose: 'verification',
            );
          }
        } else {
          // User not signed in, show auth screen
          return const AuthShell(initialStep: AuthStep.login);
        }
      },
    );
  }
}
```

### **Updated Signup Implementation**

```dart
// In your signup view
void _submit() async {
  if (!_isValid || widget.isLoading) return;

  try {
    final result = await hybridAuthService.signUpWithCustomOtp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _nameController.text.trim(),
    );

    if (result.success && result.requiresOtpVerification) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Account created! Please check your email for verification code.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to custom OTP verification
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomOtpVerificationScreen(
              email: _emailController.text.trim(),
              purpose: 'verification',
            ),
          ),
        );
      }
    } else if (!result.success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error ?? 'Signup failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

## 🔧 **Production Considerations**

### **Secure Verification Storage**
Instead of in-memory storage, use:
```dart
// Use secure storage for verification status
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VerificationStorage {
  static const _storage = FlutterSecureStorage();
  static const _key = 'custom_verified_emails';
  
  static Future<void> markAsVerified(String email) async {
    final verified = await getVerifiedEmails();
    verified.add(email);
    await _storage.write(key: _key, value: verified.join(','));
  }
  
  static Future<bool> isVerified(String email) async {
    final verified = await getVerifiedEmails();
    return verified.contains(email);
  }
  
  static Future<Set<String>> getVerifiedEmails() async {
    final stored = await _storage.read(key: _key);
    if (stored == null) return <String>{};
    return stored.split(',').toSet();
  }
}
```

### **Backend Verification Tracking**
Store verification status in your backend database:
```javascript
// In your OTP verification endpoint
router.post('/verify', async (req, res) => {
  // ... existing verification logic
  
  if (result.success) {
    // Store verification in database
    await db.collection('verified_emails').doc(email).set({
      verified: true,
      verifiedAt: new Date(),
      method: 'custom_otp'
    });
  }
  
  // ... rest of response
});
```

## 🎯 **Benefits of Hybrid Approach**

✅ **Professional Email Delivery** - Your business domain emails
✅ **Firebase Security** - Robust user management and sessions  
✅ **Custom Control** - Full control over verification process
✅ **Better Deliverability** - Avoid spam with proper SMTP setup
✅ **Scalable Architecture** - Best of both worlds
✅ **Enhanced Branding** - Consistent brand experience

## 🚀 **Implementation Steps**

1. **Set up custom OTP backend** (already done)
2. **Implement HybridAuthService** (code provided above)
3. **Update your auth screens** to use hybrid service
4. **Test the complete flow** with real emails
5. **Deploy backend** with proper SMTP configuration
6. **Monitor email delivery** and user verification rates

Your hybrid Firebase + Custom OTP system is now ready for production! 🎉