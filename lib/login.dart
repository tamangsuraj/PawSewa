import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth_service.dart';

enum AuthStep {
  login,
  signup,
  forgot,
  otpSignup,
  otpForgot,
  resetPassword,
  success,
}

enum SuccessType { accountCreated, passwordUpdated }

class AuthShell extends StatefulWidget {
  final AuthStep initialStep;
  const AuthShell({super.key, this.initialStep = AuthStep.login});

  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell> {
  late AuthStep _step;
  SuccessType _successType = SuccessType.accountCreated;
  bool _isLoading = false;

  String? _signupEmail;
  String? _forgotEmail;

  @override
  void initState() {
    super.initState();
    _step = widget.initialStep;
  }

  void _switchStep(AuthStep step) {
    setState(() {
      _step = step;
    });
  }

  Future<void> _simulateLoading(
    Future<void> Function() action,
  ) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shell = _AuthBackground(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (child, animation) {
          final offsetAnimation =
              Tween<Offset>(
                begin: const Offset(0.05, 0.02),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
        child: _buildCurrentStep(context),
      ),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(child: shell),
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context) {
    switch (_step) {
      case AuthStep.login:
        return _LoginView(
          key: const ValueKey('login'),
          isLoading: _isLoading,
          onSignupTap: () => _switchStep(AuthStep.signup),
          onForgotTap: () => _switchStep(AuthStep.forgot),
          onLoggedIn: () {
            // Navigation will be handled automatically by AuthLayout
            // No need to navigate manually
          },
        );
      case AuthStep.signup:
        return _SignupView(
          key: const ValueKey('signup'),
          isLoading: _isLoading,
          onLoginTap: () => _switchStep(AuthStep.login),
          onSignupStarted: (email) {
            _signupEmail = email;
            _simulateLoading(() async {
              _switchStep(AuthStep.success);
            });
          },
        );
      case AuthStep.forgot:
        return _ForgotPasswordView(
          key: const ValueKey('forgot'),
          isLoading: _isLoading,
          onBackToLogin: () => _switchStep(AuthStep.login),
          onCodeSent: (email) {
            _forgotEmail = email;
            _simulateLoading(() async {
              _switchStep(AuthStep.login);
            });
          },
        );
      case AuthStep.otpSignup:
        return _OtpView(
          key: const ValueKey('otpSignup'),
          isLoading: _isLoading,
          email: _signupEmail ?? 'user@example.com',
          mode: _OtpMode.signup,
          onBackToLogin: () => _switchStep(AuthStep.login),
          onVerified: () {
            _simulateLoading(() async {
              _successType = SuccessType.accountCreated;
              _switchStep(AuthStep.success);
            });
          },
        );
      case AuthStep.otpForgot:
        return _OtpView(
          key: const ValueKey('otpForgot'),
          isLoading: _isLoading,
          email: _forgotEmail ?? 'user@example.com',
          mode: _OtpMode.forgot,
          onBackToLogin: () => _switchStep(AuthStep.login),
          onVerified: () {
            _simulateLoading(() async {
              _switchStep(AuthStep.resetPassword);
            });
          },
        );
      case AuthStep.resetPassword:
        return _ResetPasswordView(
          key: const ValueKey('resetPassword'),
          isLoading: _isLoading,
          onBackToLogin: () => _switchStep(AuthStep.login),
          onPasswordUpdated: () {
            _simulateLoading(() async {
              _successType = SuccessType.passwordUpdated;
              _switchStep(AuthStep.success);
            });
          },
        );
      case AuthStep.success:
        return _SuccessView(
          key: const ValueKey('success'),
          type: _successType,
          onContinue: () => _switchStep(AuthStep.login),
        );
    }
  }
}

class _AuthBackground extends StatelessWidget {
  final Widget child;

  const _AuthBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.8, -1.0),
              radius: 1.3,
              colors: [Color(0xFFFFF7EB), Color(0xFFF3E4D3), Color(0xFFE6D0BC)],
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: _BlurCircle(size: 220, color: primary.withValues(alpha: 0.12)),
        ),
        Positioned(
          bottom: -60,
          left: -40,
          child: _BlurCircle(
            size: 200,
            color: const Color(0xFFB37A4D).withValues(alpha: 0.18),
          ),
        ),
        Positioned(
          bottom: 120,
          right: 30,
          child: Opacity(
            opacity: 0.13,
            child: Image.asset(
              'assets/logo/main_logo.png',
              width: 96,
              height: 96,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _BrandHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: Image.asset(
                'assets/logo/main_logo.png',
                width: 42,
                height: 42,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PawSewa',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primary,
                    letterSpacing: 0.4,
                  ),
                ),
                Text(
                  'Premium pet care',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF9E8166),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4C2A16),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF93765B)),
        ),
      ],
    );
  }
}

class _AuthCard extends StatelessWidget {
  final Widget child;

  const _AuthCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading == true
        ? true
        : false;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTapDown: isDisabled ? null : _onTapDown,
      onTapUp: isDisabled ? null : _onTapUp,
      onTapCancel: isDisabled ? null : _onTapCancel,
      onTap: isDisabled ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          height: 52,
          decoration: BoxDecoration(
            color: isDisabled
                ? colorScheme.primary.withValues(alpha: 0.35)
                : colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDisabled
                ? null
                : [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.28),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.onPrimary,
                    ),
                  ),
                )
              : Text(
                  widget.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isGoogle;

  const _SecondaryButton({
    required this.label,
    this.onPressed,
    this.isGoogle = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          isGoogle ? Icons.g_mobiledata_rounded : Icons.pets_rounded,
          size: isGoogle ? 28 : 20,
          color: colorScheme.primary,
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.28),
            width: 1.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          foregroundColor: colorScheme.primary,
          textStyle: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        label: Text(label),
      ),
    );
  }
}

class _MutedErrorText extends StatelessWidget {
  final String text;

  const _MutedErrorText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: const Color(0xFFB97C5E)),
    );
  }
}

class _LoginView extends StatefulWidget {
  final VoidCallback onSignupTap;
  final VoidCallback onForgotTap;
  final VoidCallback onLoggedIn;
  final bool isLoading;

  const _LoginView({
    super.key,
    required this.onSignupTap,
    required this.onForgotTap,
    required this.onLoggedIn,
    required this.isLoading,
  });

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _remember = true;
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isValid => _formKey.currentState?.validate() ?? false;

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your email';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Please enter your password';
    if (v.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    if (!_isValid || widget.isLoading) return;

    try {
      await authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // Navigation will be handled automatically by AuthLayout
      widget.onLoggedIn();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AuthCard(
      child: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _BrandHeader(
              title: 'Welcome back',
              subtitle: 'Let’s take care of your pet',
            ),
            const SizedBox(height: 28),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@example.com',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '- - - - - - - - ',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                    _showPassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
              ),
              obscureText: !_showPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: _validatePassword,
            ),
            const SizedBox(height: 6),
            Text(
              'At least 8 characters',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFFAA8D71)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _remember,
                  onChanged: (v) {
                    setState(() {
                      _remember = v ?? false;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: BorderSide(
                    color: const Color(0xFFB8A18B).withValues(alpha: 0.9),
                  ),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Remember me',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF7E6248),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: widget.isLoading ? null : widget.onForgotTap,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Forgot password?'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _PrimaryButton(
              label: 'Log in',
              isLoading: widget.isLoading,
              onPressed: _isValid && !widget.isLoading ? _submit : null,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Container(height: 1, color: const Color(0xFFE4D2BE)),
                ),
                const SizedBox(width: 8),
                Text(
                  'or',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFB29B83),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(height: 1, color: const Color(0xFFE4D2BE)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SecondaryButton(
              label: 'Continue with Google',
              isGoogle: true,
              onPressed: widget.isLoading
                  ? null
                  : () async {
                      try {
                        final userCredential = await authService.signInWithGoogle();
                        if (userCredential.user != null) {
                          widget.onLoggedIn();
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
            ),
            const SizedBox(height: 18),
            Center(
              child: TextButton(
                onPressed: widget.isLoading ? null : widget.onSignupTap,
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF8B6A4B),
                    ),
                    children: [
                      const TextSpan(text: "Don’t have an account? "),
                      TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
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

class _SignupView extends StatefulWidget {
  final VoidCallback onLoginTap;
  final bool isLoading;
  final void Function(String email) onSignupStarted;

  const _SignupView({
    super.key,
    required this.onLoginTap,
    required this.isLoading,
    required this.onSignupStarted,
  });

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your full name';
    if (v.length < 3) return 'Name looks too short';
    return null;
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your email';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Create a password';
    if (v.length < 8) return 'At least 8 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final v = value ?? '';
    if (v != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  bool get _isValid {
    final valid = _formKey.currentState?.validate() ?? false;
    return valid && _agreed;
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    if (!_isValid || widget.isLoading) return;

    try {
      await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Send email verification
      await authService.sendEmailVerification();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please verify your email.'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSignupStarted(_emailController.text.trim());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AuthCard(
      child: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _BrandHeader(
              title: 'Create an account',
              subtitle: 'For calmer, happier pet days',
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                hintText: 'Alex Sharma',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              textInputAction: TextInputAction.next,
              validator: _validateName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@example.com',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '- - - - - - - - ',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                    _showPassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
              ),
              obscureText: !_showPassword,
              textInputAction: TextInputAction.next,
              validator: _validatePassword,
            ),
            const SizedBox(height: 6),
            Text(
              'Use at least 8 characters for a strong password',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFFAA8D71)),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm password',
                hintText: '- - - - - - - - ',
                prefixIcon: const Icon(Icons.lock_person_outlined),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _showConfirmPassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
              ),
              obscureText: !_showConfirmPassword,
              textInputAction: TextInputAction.done,
              validator: _validateConfirmPassword,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _agreed,
                  onChanged: (v) {
                    setState(() {
                      _agreed = v ?? false;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: BorderSide(
                    color: const Color(0xFFB8A18B).withValues(alpha: 0.9),
                  ),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF7E6248),
                      ),
                      children: const [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms & Privacy',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!_agreed)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: _MutedErrorText('Please accept the terms to continue'),
              ),
            const SizedBox(height: 10),
            _PrimaryButton(
              label: 'Create account',
              isLoading: widget.isLoading,
              onPressed: _isValid && !widget.isLoading ? _submit : null,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Container(height: 1, color: const Color(0xFFE4D2BE)),
                ),
                const SizedBox(width: 8),
                Text(
                  'or',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFB29B83),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(height: 1, color: const Color(0xFFE4D2BE)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SecondaryButton(
              label: 'Sign up with Google',
              isGoogle: true,
              onPressed: widget.isLoading
                  ? null
                  : () async {
                      try {
                        final userCredential = await authService.signInWithGoogle();
                        if (userCredential.user != null) {
                          // For Google Sign-In, the user is automatically verified
                          // Navigate to success or main screen
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Welcome ${userCredential.user!.displayName ?? 'User'}!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            widget.onSignupStarted(userCredential.user!.email ?? '');
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
            ),
            const SizedBox(height: 18),
            Center(
              child: TextButton(
                onPressed: widget.isLoading ? null : widget.onLoginTap,
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF8B6A4B),
                    ),
                    children: [
                      const TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
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

class _ForgotPasswordView extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onBackToLogin;
  final void Function(String email) onCodeSent;

  const _ForgotPasswordView({
    super.key,
    required this.isLoading,
    required this.onBackToLogin,
    required this.onCodeSent,
  });

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your email';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  bool get _isValid => _formKey.currentState?.validate() ?? false;

  void _submit() async {
    FocusScope.of(context).unfocus();
    if (!_isValid || widget.isLoading) return;

    try {
      await authService.sendPasswordResetEmail(email: _emailController.text.trim());
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onCodeSent(_emailController.text.trim());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AuthCard(
      child: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _BrandHeader(
              title: 'Reset password',
              subtitle: 'Enter your email and we’ll send a reset code',
            ),
            const SizedBox(height: 26),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@example.com',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: _validateEmail,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            _PrimaryButton(
              label: 'Send code',
              isLoading: widget.isLoading,
              onPressed: _isValid && !widget.isLoading ? _submit : null,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: widget.isLoading ? null : widget.onBackToLogin,
                icon: const Icon(Icons.chevron_left_rounded),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  minimumSize: const Size(0, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                label: const Text('Back to login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _OtpMode { signup, forgot }

class _OtpView extends StatefulWidget {
  final String email;
  final _OtpMode mode;
  final bool isLoading;
  final VoidCallback onVerified;
  final VoidCallback onBackToLogin;

  const _OtpView({
    super.key,
    required this.email,
    required this.mode,
    required this.isLoading,
    required this.onVerified,
    required this.onBackToLogin,
  });

  @override
  State<_OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<_OtpView> {
  final int _otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  int _secondsRemaining = 30;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    final seconds = 30 - elapsed.inSeconds;
    if (seconds <= 0) {
      _ticker.stop();
      setState(() {
        _secondsRemaining = 0;
      });
    } else {
      setState(() {
        _secondsRemaining = seconds;
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _ticker.dispose();
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text.trim()).join();

  bool get _isComplete => _code.length == _otpLength;

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value.characters.last;
      _controllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: 1),
      );
    }
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  KeyEventResult _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].text = '';
      _controllers[index - 1].selection = TextSelection.fromPosition(
        const TextPosition(offset: 0),
      );
      setState(() {});
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _resend() {
    if (_secondsRemaining > 0 || widget.isLoading) return;
    for (final c in _controllers) {
      c.clear();
    }
    _ticker.stop();
    _ticker.start();
    setState(() {
      _secondsRemaining = 30;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.mode == _OtpMode.signup
              ? 'Verification code resent (mock)'
              : 'Reset code resent (mock)',
        ),
      ),
    );
  }

  void _verify() {
    if (!_isComplete) return;
    widget.onVerified();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.mode == _OtpMode.signup
        ? 'Verify your email'
        : 'Verify reset code';
    final textTheme = Theme.of(context).textTheme;
    return _AuthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BrandHeader(
            title: title,
            subtitle:
                'We sent a 6-digit code to ${widget.email.isEmpty ? 'your email' : widget.email}',
          ),
          const SizedBox(height: 24),
          Text(
            'Enter code',
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF7E6248),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_otpLength, (index) {
              return SizedBox(
                width: 44,
                child: Focus(
                  focusNode: _focusNodes[index],
                  onKeyEvent: (node, event) => _onKeyEvent(index, event),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    showCursor: false,
                    style: textTheme.titleMedium?.copyWith(
                      letterSpacing: 1.2,
                      color: const Color(0xFF4C2A16),
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      filled: true,
                      fillColor: const Color(0xFFFFFBF5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFD6C4AF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFD6C4AF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.4,
                        ),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => _onDigitChanged(index, v),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: const Color(0xFFAA8D71),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Codes expire quickly for your security.',
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFAA8D71),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _PrimaryButton(
                label: 'Verify',
                isLoading: widget.isLoading,
                onPressed: _isComplete && !widget.isLoading ? _verify : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _secondsRemaining == 0 && !widget.isLoading
                          ? _resend
                          : null,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 34),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Resend code',
                        style: textTheme.bodyMedium?.copyWith(
                          color: _secondsRemaining == 0
                              ? Theme.of(context).colorScheme.primary
                              : const Color(0xFFB8A18B),
                        ),
                      ),
                    ),
                    Text(
                      _secondsRemaining == 0
                          ? 'You can request a new code'
                          : 'in ${_secondsRemaining}s',
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFB8A18B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: widget.isLoading ? null : widget.onBackToLogin,
              icon: const Icon(Icons.chevron_left_rounded),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              label: const Text('Back to login'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResetPasswordView extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPasswordUpdated;
  final VoidCallback onBackToLogin;

  const _ResetPasswordView({
    super.key,
    required this.isLoading,
    required this.onPasswordUpdated,
    required this.onBackToLogin,
  });

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _showConfirm = false;

  String _password = '';

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Create a password';
    if (v.length < 8) return 'At least 8 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final v = value ?? '';
    if (v != _password) return 'Passwords do not match';
    return null;
  }

  bool get _isValid => _formKey.currentState?.validate() ?? false;

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_isValid) return;
    widget.onPasswordUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return _AuthCard(
      child: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _BrandHeader(
              title: 'Create new password',
              subtitle: 'Choose a secure password you’ll remember',
            ),
            const SizedBox(height: 26),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'New password',
                hintText: '- - - - - - - - ',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                    _showPassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
              ),
              obscureText: !_showPassword,
              textInputAction: TextInputAction.next,
              validator: _validatePassword,
              onChanged: (v) => _password = v,
            ),
            const SizedBox(height: 6),
            Text(
              'At least 8 characters, avoid common words',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFFAA8D71)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm password',
                hintText: '- - - - - - - - ',
                prefixIcon: const Icon(Icons.lock_person_outlined),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showConfirm = !_showConfirm;
                    });
                  },
                  icon: Icon(
                    _showConfirm
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
              ),
              obscureText: !_showConfirm,
              textInputAction: TextInputAction.done,
              validator: _validateConfirmPassword,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 22),
            _PrimaryButton(
              label: 'Update password',
              isLoading: widget.isLoading,
              onPressed: _isValid && !widget.isLoading ? _submit : null,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: widget.isLoading ? null : widget.onBackToLogin,
                icon: const Icon(Icons.chevron_left_rounded),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  minimumSize: const Size(0, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                label: const Text('Back to login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatefulWidget {
  final SuccessType type;
  final VoidCallback onContinue;

  const _SuccessView({super.key, required this.type, required this.onContinue});

  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAccount = widget.type == SuccessType.accountCreated;
    final title = isAccount ? 'Account created' : 'Password updated';
    final subtitle = isAccount
        ? 'Your PawSewa profile is ready.\nLet’s make life softer for your pet.'
        : 'Your new password is all set.\nYou can log in with your updated details.';
    return _AuthCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scale,
            child: FadeTransition(
              opacity: _opacity,
              child: Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.95),
                      const Color(0xFFB37A4D),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 26,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 42,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF4C2A16),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF93765B)),
          ),
          const SizedBox(height: 24),
          _PrimaryButton(
            label: isAccount ? 'Continue to login' : 'Back to login',
            onPressed: widget.onContinue,
          ),
        ],
      ),
    );
  }
}

class Ticker {
  final void Function(Duration elapsed) onTick;
  late final Stopwatch _stopwatch;
  late final Duration _interval;
  bool _isActive = false;

  Ticker(this.onTick, {Duration interval = const Duration(seconds: 1)}) {
    _interval = interval;
    _stopwatch = Stopwatch();
  }

  void start() async {
    if (_isActive) return;
    _isActive = true;
    _stopwatch.reset();
    _stopwatch.start();
    while (_isActive) {
      await Future.delayed(_interval);
      if (!_isActive) break;
      onTick(_stopwatch.elapsed);
    }
  }

  void stop() {
    _isActive = false;
    _stopwatch.stop();
  }

  void dispose() {
    stop();
  }
}
