import 'package:flutter/material.dart';
import 'auth_layout.dart';
import 'splash_screen.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _hideSplashScreen();
  }

  void _hideSplashScreen() async {
    await Future.delayed(const Duration(seconds: 6));
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashWrapper();
    }
    return const AuthLayout();
  }
}