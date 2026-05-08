import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/responsive_layout.dart';
import '../../../control/presentation/pages/connect_page.dart';
import '../bloc/auth_bloc.dart';
import 'login_page.dart';
import 'mobile/signup_mobile.dart';
import 'web/signup_web.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignUpRequested(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
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
          mobileBody: SignUpMobile(
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            formKey: _formKey,
            onSignUp: _signUp,
            onLogin: _navigateToLogin,
          ),
          webBody: SignUpWeb(
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            formKey: _formKey,
            onSignUp: _signUp,
            onLogin: _navigateToLogin,
          ),
        ),
      ),
    );
  }
}
