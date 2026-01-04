import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Get ID token for API requests
  Future<String?> getIdToken() async {
    try {
      final user = currentUser;
      if (user != null) {
        return await user.getIdToken();
      }
      return null;
    } catch (e) {
      throw 'Failed to get ID token: $e';
    }
  }

  // Sign up with email and password using createUserWithEmailAndPassword()
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Automatically send email verification after signup
      await sendEmailVerification();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred during signup. Please try again.';
    }
  }

  // Sign in with email and password using signInWithEmailAndPassword()
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred during sign in. Please try again.';
    }
  }

  // Sign out user
  Future<void> signOut() async {
    try {
      // Sign out from both Firebase and Google
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw 'Failed to sign out. Please try again.';
    }
  }

  // Google Sign-In
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Sign out first to ensure fresh authentication
      await _googleSignIn.signOut();

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Google Sign-In was cancelled by user';
      }

      // Obtain the authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Verify we got the tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw 'Failed to get authentication tokens from Google';
      }

      // Create a new credential for Firebase Authentication
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign-in with Firebase using the Google credentials
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Log Firebase auth errors
      print('🔥 FirebaseAuthException: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      // Enhanced error logging for debugging
      print('❌ Google Sign-In Error: ${e.toString()}');
      print('Error type: ${e.runtimeType}');

      // Handle specific error cases
      if (e.toString().contains('cancelled')) {
        throw 'Google Sign-In was cancelled';
      }

      // Detect ApiException: 10 (DEVELOPER_ERROR)
      if (e.toString().contains('ApiException: 10') ||
          e.toString().contains('DEVELOPER_ERROR')) {
        throw 'Google Sign-In failed: OAuth client not configured.\n\n'
            'Please check:\n'
            '1. SHA-1 and SHA-256 added to Firebase\n'
            '2. OAuth Client IDs created in Google Cloud Console\n'
            '3. Web Client ID added to Firebase Authentication\n'
            '4. google-services.json re-downloaded\n\n'
            'See GOOGLE_SIGNIN_FIX_GUIDE.md for details.';
      }

      // Detect ApiException: 7 (NETWORK_ERROR)
      if (e.toString().contains('ApiException: 7')) {
        throw 'Network error. Please check your internet connection.';
      }

      // Detect ApiException: 12500 (SIGN_IN_CANCELLED)
      if (e.toString().contains('ApiException: 12500')) {
        throw 'Google Sign-In was cancelled';
      }

      throw 'Google Sign-In failed: ${e.toString()}';
    }
  }

  // Check if user is signed in with Google
  bool get isSignedInWithGoogle => _googleSignIn.currentUser != null;

  // Get Google user info
  GoogleSignInAccount? get googleUser => _googleSignIn.currentUser;

  // Send password reset email using sendPasswordResetEmail()
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to send password reset email. Please try again.';
    }
  }

  // Send email verification using sendEmailVerification()
  Future<void> sendEmailVerification() async {
    try {
      final user = currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      } else if (user == null) {
        throw 'No user is currently signed in.';
      } else {
        throw 'Email is already verified.';
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to send verification email: $e';
    }
  }

  // Confirm password reset using confirmPasswordReset()
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to reset password. Please try again.';
    }
  }

  // Verify password reset code
  Future<String> verifyPasswordResetCode(String code) async {
    try {
      return await _auth.verifyPasswordResetCode(code);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Invalid or expired reset code.';
    }
  }

  // Check if email is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  // Reload user data to get updated email verification status
  Future<void> reloadUser() async {
    try {
      await currentUser?.reload();
    } catch (e) {
      // Silently fail for reload
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to delete account. Please try again.';
    }
  }

  // Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to update password. Please try again.';
    }
  }

  // Handle Firebase Auth exceptions with user-friendly messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak. Please use at least 8 characters.';
      case 'email-already-in-use':
        return 'An account already exists with that email address.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'invalid-credential':
        return 'The email or password is incorrect.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again.';
      case 'expired-action-code':
        return 'The action code has expired. Please request a new one.';
      case 'invalid-action-code':
        return 'The action code is invalid. Please check the link and try again.';
      case 'user-token-expired':
        return 'Your session has expired. Please sign in again.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      default:
        return e.message ??
            'An authentication error occurred. Please try again.';
    }
  }
}

// Global instance
final authService = AuthService();
