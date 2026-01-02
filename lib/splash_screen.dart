import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'auth_layout.dart';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _loadingScale;
  late final Animation<double> _loadingOpacity;
  late final Animation<Offset> _brownSlide;
  late final Animation<Offset> _loginSlide;

  @override
  void initState() {
    super.initState();

    // 0–1500 ms : white only
    // 1500–3500 ms : logo + lottie visible (with pop-in, loading held longer)
    // 3500–6000 ms : brown wipe + login sliding together
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AuthLayout()),
          );
        }
      });

    // Logo pop from 1.5–1.9 s  -> 1.5/6=0.25, 1.9/6≈0.317
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.317, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.317, curve: Curves.easeOut),
      ),
    );

    // Loading pop & hold longer: start after logo, still end at ~0.383
    _loadingScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.267, 0.383, curve: Curves.easeOutBack),
      ),
    );

    _loadingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.267, 0.383, curve: Curves.easeOut),
      ),
    );

    // Brown + login slide 3.5–6 s -> 3.5/6≈0.583 (unchanged)
    _brownSlide = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // off-screen right
      end: const Offset(-1.0, 0.0), // off-screen left
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.583, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    _loginSlide = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.583, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _brown => const Color(0xFF7A4B3A);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value; // 0 → 1 over 6 seconds

          return Stack(
            children: [
              // 1) AuthLayout sliding in from right (attached to brown)
              if (t >= 0.583)
                SlideTransition(
                  position: _loginSlide,
                  child: const AuthLayout(),
                ),

              // 2) Logo / loading screen – now also visible under the brown wipe
              if (t < 0.583)
                Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Phase 1: 0–1.5 s -> white only
                      if (t < 0.25)
                        const SizedBox.shrink()
                      else
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo pop-in, a bit smaller and smoothly zoomed
                            Opacity(
                              opacity: t < 0.25
                                  ? 0.0
                                  : (t < 0.317 ? _logoOpacity.value : 1.0),
                              child: Transform.scale(
                                scale: t < 0.25
                                    ? 0.7
                                    : (t < 0.317 ? _logoScale.value : 1.0),
                                child: Image.asset(
                                  'assets/logo/logo.png',
                                  width: size.width * 0.35, // was 0.4
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Loading pop-in, half size and smooth zoom
                            Opacity(
                              opacity: t < 0.267
                                  ? 0.0
                                  : (t < 0.383 ? _loadingOpacity.value : 1.0),
                              child: Transform.scale(
                                scale: t < 0.267
                                    ? 0.7
                                    : (t < 0.383 ? _loadingScale.value : 1.0),
                                child: SizedBox(
                                  height: 30,
                                  child: Lottie.asset(
                                    'assets/animations/loading.json',
                                    repeat: true,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

              // 3) Brown rectangle on top during the wipe, passing over logo/loading.
              if (t >= 0.583 && t < 1.0)
                SlideTransition(
                  position: _brownSlide,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width * 960, // 4x previous 240x
                      height: size.height,
                      color: _brown,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
