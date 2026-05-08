import 'package:controlx/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/responsive_layout.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'connect_page.dart';
import 'mobile/splash_mobile.dart';
import 'web/splash_web.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _animationCompleted = true;
        });
        _checkAndNavigate(context.read<AuthBloc>().state);
      }
    });
  }

  void _checkAndNavigate(AuthState state) {
    if (!_animationCompleted) return;
    if (state is AuthInitial || state is AuthLoading) return; // Wait for definitive state

    Widget next = const LoginPage();
    if (state is AuthAuthenticated) {
      next = const ConnectPage();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _checkAndNavigate(state);
      },
      child: Scaffold(
        body: ResponsiveLayout(
          mobileBody: SplashMobile(fadeAnimation: _fadeAnimation),
          webBody: SplashWeb(fadeAnimation: _fadeAnimation),
        ),
      ),
    );
  }
}
