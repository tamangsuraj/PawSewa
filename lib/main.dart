import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'pet_hostel.dart';
import 'splash_screen.dart';
import 'login.dart';
import 'services.dart';
import 'auth_layout.dart';
// Routes for test screens removed
import 'upgradetopro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Premium Service
  await PremiumStateService().initialize();

  runApp(const PetStoreApp());
}

class PetStoreApp extends StatelessWidget {
  const PetStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Store',
      theme: ThemeData(
        primaryColor: const Color(0xFF7A4B3A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7A4B3A),
          primary: const Color(0xFF7A4B3A),
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter', // Modern sans-serif font
        // Reduced base text sizes for better proportions
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 14),
          bodyMedium: TextStyle(fontSize: 13),
          bodySmall: TextStyle(fontSize: 12),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF7A4B3A), width: 2),
          ),
          labelStyle: const TextStyle(fontSize: 14),
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          alignLabelWithHint: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7A4B3A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            minimumSize: const Size(0, 52), // Consistent button height
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),
      home: const SplashWrapper(),
      routes: {
        '/auth': (context) => const AuthLayout(),
        '/login': (context) => const AuthShell(initialStep: AuthStep.login),
        '/signup': (context) => const AuthShell(initialStep: AuthStep.signup),
        '/forgot-password': (context) =>
            const AuthShell(initialStep: AuthStep.forgot),
        '/home': (context) => const MainScreen(),
        '/services': (context) => const ServicesShell(),
        '/detail': (context) => HostelDetailPage(),
        '/booking': (context) => BookingPage(),
        '/pricing': (context) => PricingPage(),
        '/confirmation': (context) => ConfirmationPage(),
      },
    );
  }
}
