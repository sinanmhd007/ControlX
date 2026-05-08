import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../control/presentation/widgets/glass_card.dart';
import '../../bloc/auth_bloc.dart';

class LoginWeb extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  const LoginWeb({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.onLogin,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        padding: const EdgeInsets.all(40.0),
        child: Row(
          children: [
            // Left side text and icon
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_person, size: 100, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 32),
                  Text(
                    'Welcome Back to ControlX',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sign in securely to manage your devices from anywhere. Experience the ultimate control from your desktop.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 60),
            // Right side form
            Expanded(
              child: Form(
                key: formKey,
                child: GlassCard(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Authentication Required',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your email';
                          if (!value.contains('@')) return 'Please enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your password';
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return ElevatedButton(
                            onPressed: onLogin,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              minimumSize: const Size(double.infinity, 60),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            child: const Text('Log In', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?', style: TextStyle(color: Colors.white70)),
                          TextButton(
                            onPressed: onSignUp,
                            child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                          ),
                        ],
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
