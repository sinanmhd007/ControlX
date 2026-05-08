import 'package:flutter/material.dart';

class SplashWeb extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const SplashWeb({super.key, required this.fadeAnimation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withValues(alpha: .5),
                    blurRadius: 40,
                    spreadRadius: 10,
                  )
                ]
              ),
              child: const Icon(Icons.computer, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 32),
            Text(
              'ControlX',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The Ultimate Remote Laptop Manager for Web & Desktop',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
