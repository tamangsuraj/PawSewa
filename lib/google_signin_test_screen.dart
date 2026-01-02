import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class GoogleSignInTestScreen extends StatefulWidget {
  const GoogleSignInTestScreen({super.key});

  @override
  State<GoogleSignInTestScreen> createState() => _GoogleSignInTestScreenState();
}

class _GoogleSignInTestScreenState extends State<GoogleSignInTestScreen> {
  String _output = '';
  bool _isLoading = false;

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

  Future<void> _testGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _log('🔄 Starting Google Sign-In...');
      
      final userCredential = await authService.signInWithGoogle();
      final user = userCredential.user;
      
      if (user != null) {
        _log('✅ Google Sign-In successful!');
        _log('👤 User: ${user.displayName ?? 'No name'}');
        _log('📧 Email: ${user.email ?? 'No email'}');
        _log('🆔 UID: ${user.uid}');
        _log('📸 Photo: ${user.photoURL ?? 'No photo'}');
        _log('✅ Email verified: ${user.emailVerified}');
        
        // Check provider data
        _log('🔗 Sign-in providers:');
        for (final provider in user.providerData) {
          _log('   - ${provider.providerId}');
        }
        
        // Check if it's a Google user
        final isGoogleUser = user.providerData.any((provider) => provider.providerId == 'google.com');
        _log('🔍 Is Google user: $isGoogleUser');
        
      } else {
        _log('❌ Sign-in failed: No user returned');
      }
    } catch (e) {
      _log('❌ Google Sign-In failed: $e');
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
      _log('🔄 Signing out...');
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

  void _checkCurrentUser() {
    final user = authService.currentUser;
    if (user != null) {
      _log('👤 Current user: ${user.displayName ?? user.email ?? 'Unknown'}');
      _log('📧 Email: ${user.email ?? 'No email'}');
      _log('✅ Email verified: ${user.emailVerified}');
      
      final isGoogleUser = user.providerData.any((provider) => provider.providerId == 'google.com');
      _log('🔍 Is Google user: $isGoogleUser');
      
      _log('🔗 Providers: ${user.providerData.map((p) => p.providerId).join(', ')}');
    } else {
      _log('❌ No current user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign-In Test'),
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
            // Current user info
            StreamBuilder<User?>(
              stream: authService.authStateChanges,
              builder: (context, snapshot) {
                final user = snapshot.data;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: user != null ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: user != null ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Authentication Status',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (user != null) ...[
                        Text('✅ Signed in as: ${user.displayName ?? user.email ?? 'Unknown'}'),
                        if (user.photoURL != null) ...[
                          const SizedBox(height: 8),
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.photoURL!),
                            radius: 20,
                          ),
                        ],
                      ] else ...[
                        const Text('❌ Not signed in'),
                      ],
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Test buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testGoogleSignIn,
                  icon: const Icon(Icons.login),
                  label: const Text('Test Google Sign-In'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testSignOut,
                  icon: const Icon(Icons.logout),
                  label: const Text('Test Sign Out'),
                ),
                ElevatedButton.icon(
                  onPressed: _checkCurrentUser,
                  icon: const Icon(Icons.person),
                  label: const Text('Check Current User'),
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