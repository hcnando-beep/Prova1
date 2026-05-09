import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/vero_theme.dart';
import 'login_screen.dart';
import 'dashboard/consultant_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final Animation<double> _tagline;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));
    _scale   = Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.7, curve: Curves.elasticOut)));
    _opacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.45, curve: Curves.easeIn)));
    _tagline = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)));
    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => auth.isAuthenticated
            ? const ConsultantDashboardScreen()
            : const LoginScreen(),
      ));
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [VeroColors.gradientStart, VeroColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: _opacity.value,
                  child: Transform.scale(
                    scale: _scale.value,
                    child: Container(
                      width: 140, height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.13),
                        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('VERO',
                              style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900,
                                  color: Colors.white, letterSpacing: 2)),
                          Text('COSMÉTICOS',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold,
                                  color: Colors.white, letterSpacing: 5)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Opacity(
                  opacity: _tagline.value,
                  child: Column(children: [
                    Text('Beleza que transforma vidas',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9))),
                    const SizedBox(height: 6),
                    Text('Para consultoras que fazem a diferença',
                        style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.65))),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
