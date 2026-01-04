import 'package:flutter/material.dart';
import 'ui/screens/main_screen.dart';
import 'ui/screens/pet_hostel_screen.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/services_screen.dart';
import 'ui/screens/auth_layout_screen.dart';
import 'ui/screens/auth_test_screen.dart';
import 'ui/screens/google_signin_test_screen.dart';
import 'core/constants/app_theme.dart';

class PawSewaApp extends StatelessWidget {
  const PawSewaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawSewa',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/auth': (context) => const AuthLayoutScreen(),
        '/login': (context) => const LoginScreen(initialStep: AuthStep.login),
        '/signup': (context) => const LoginScreen(initialStep: AuthStep.signup),
        '/forgot-password': (context) =>
            const LoginScreen(initialStep: AuthStep.forgot),
        '/home': (context) => const MainScreen(),
        '/services': (context) => const ServicesScreen(),
        '/detail': (context) => const HostelDetailScreen(),
        '/booking': (context) => const BookingScreen(),
        '/pricing': (context) => const PricingScreen(),
        '/confirmation': (context) => const ConfirmationScreen(),
        '/auth-test': (context) => const AuthTestScreen(),
        '/google-signin-test': (context) => const GoogleSignInTestScreen(),
      },
    );
  }
}