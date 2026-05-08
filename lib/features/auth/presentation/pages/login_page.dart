import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/responsive_layout.dart';
import '../../../control/presentation/pages/connect_page.dart';
import '../bloc/auth_bloc.dart';
import 'signup_page.dart';
import 'mobile/login_mobile.dart';
import 'web/login_web.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );
    }
  }

  void _navigateToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ConnectPage()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        child: ResponsiveLayout(
          mobileBody: LoginMobile(
            emailController: _emailController,
            passwordController: _passwordController,
            formKey: _formKey,
            onLogin: _login,
            onSignUp: _navigateToSignUp,
          ),
          webBody: LoginWeb(
            emailController: _emailController,
            passwordController: _passwordController,
            formKey: _formKey,
            onLogin: _login,
            onSignUp: _navigateToSignUp,
          ),
        ),
      ),
    );
  }
}
