import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'main_screen.dart';
import 'login.dart';
import 'email_verification_screen.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Check if user is authenticated
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          
          // Check if email is verified OR if user signed in with Google
          // Google users are automatically verified
          final isGoogleUser = user.providerData.any((provider) => provider.providerId == 'google.com');
          
          if (!user.emailVerified && !isGoogleUser) {
            // Show email verification screen for email/password users only
            return const EmailVerificationScreen();
          }
          
          // User is signed in and verified (or Google user), show main app
          return const MainScreen();
        } else {
          // User is not signed in, show auth screen
          return pageIfNotConnected ?? const AuthShell(initialStep: AuthStep.login);
        }
      },
    );
  }
}
