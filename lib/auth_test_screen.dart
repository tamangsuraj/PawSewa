import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _resetCodeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  
  String _output = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _resetCodeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _log(String message) {
    setState(() {
      _output += '${DateTime.now().toString().substring(11, 19)}: $message\n';
    });
  }

  void _clearLog() {
    setState(() {
      _output = '';
    });
  }

  Future<void> _testSignUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _log('❌ Please enter email and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _log('🔄 Testing createUserWithEmailAndPassword()...');
      final result = await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      _log('✅ Sign up successful: ${result.user?.email}');
      _log('📧 Email verification sent automatically');
      _log('🔍 Email verified: ${result.user?.emailVerified}');
    } catch (e) {
      _log('❌ Sign up failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _log('❌ Please enter email and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _log('🔄 Testing signInWithEmailAndPassword()...');
      final result = await authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      _log('✅ Sign in successful: ${result.user?.email}');
      _log('🔍 Email verified: ${result.user?.emailVerified}');
      
      // Test getting ID token
      final idToken = await authService.getIdToken();
      _log('🎫 ID Token obtained: ${idToken?.substring(0, 20)}...');
    } catch (e) {
      _log('❌ Sign in failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testPasswordReset() async {
    if (_emailController.text.isEmpty) {
      _log('❌ Please enter email');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _log('🔄 Testing sendPasswordResetEmail()...');
      await authService.sendPasswordResetEmail(email: _emailController.text.trim());
      _log('✅ Password reset email sent successfully');
      _log('📧 Check your inbox for reset link');
    } catch (e) {
      _log('❌ Password reset failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testEmailVerification() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _log('🔄 Testing sendEmailVerification()...');
      await authService.sendEmailVerification();
      _log('✅ Email verification sent successfully');
      _log('📧 Check your inbox for verification link');
    } catch (e) {
      _log('❌ Email verification failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testConfirmPasswordReset() async {
    if (_resetCodeController.text.isEmpty || _newPasswordController.text.isEmpty) {
      _log('❌ Please enter reset code and new password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _log('🔄 Testing confirmPasswordReset()...');
      await authService.confirmPasswordReset(
        code: _resetCodeController.text.trim(),
        newPassword: _newPasswordController.text,
      );
      _log('✅ Password reset confirmed successfully');
    } catch (e) {
      _log('❌ Password reset confirmation failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testSignOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _log('🔄 Testing signOut()...');
      await authService.signOut();
      _log('✅ Sign out successful');
    } catch (e) {
      _log('❌ Sign out failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testAuthState() async {
    _log('🔄 Testing authStateChanges()...');
    final user = authService.currentUser;
    if (user != null) {
      _log('✅ Current user: ${user.email}');
      _log('🔍 Email verified: ${user.emailVerified}');
      _log('🆔 UID: ${user.uid}');
    } else {
      _log('❌ No current user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Auth Test'),
        actions: [
          IconButton(
            onPressed: _clearLog,
            icon: const Icon(Icons.clear),
            tooltip: 'Clear Log',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'test@example.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'password123',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _resetCodeController,
              decoration: const InputDecoration(
                labelText: 'Reset Code (from email)',
                hintText: 'Enter code from reset email',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                hintText: 'newpassword123',
              ),
              obscureText: true,
            ),
            
            const SizedBox(height: 16),
            
            // Test buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _testSignUp,
                  child: const Text('Test Sign Up'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testSignIn,
                  child: const Text('Test Sign In'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testPasswordReset,
                  child: const Text('Test Password Reset'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testEmailVerification,
                  child: const Text('Test Email Verification'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testConfirmPasswordReset,
                  child: const Text('Test Confirm Reset'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testSignOut,
                  child: const Text('Test Sign Out'),
                ),
                ElevatedButton(
                  onPressed: _testAuthState,
                  child: const Text('Check Auth State'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (_isLoading)
              const LinearProgressIndicator(),
            
            const SizedBox(height: 16),
            
            // Output log
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _output.isEmpty ? 'Test output will appear here...' : _output,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}