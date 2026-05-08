import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../control/presentation/widgets/glass_card.dart';
import '../../bloc/auth_bloc.dart';

class LoginMobile extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  const LoginMobile({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.onLogin,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Icon(Icons.lock_person, size: 80, color: Theme.of(context).primaryColor),
              const SizedBox(height: 32),
              Text(
                'Welcome Back to ControlX',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in securely to manage your devices from anywhere.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              GlassCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Text(
                      'Authentication Required',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 32),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return ElevatedButton(
                          onPressed: onLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 56),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text('Log In', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  ],
                ),
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
