import 'package:flutter/material.dart';

class SplashMobile extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const SplashMobile({super.key, required this.fadeAnimation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
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
                    blurRadius: 30,
                    spreadRadius: 5,
                  )
                ]
              ),
              child: const Icon(Icons.computer, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'ControlX',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Remote Laptop Manager',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
