import 'package:flutter/material.dart';
import '../../widgets/glass_card.dart';

class ConnectWeb extends StatelessWidget {
  final TextEditingController ipController;
  final TextEditingController codeController;
  final VoidCallback onConnect;

  const ConnectWeb({
    super.key,
    required this.ipController,
    required this.codeController,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(40.0),
        child: GlassCard(
          padding: const EdgeInsets.all(40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_tethering,
                      size: 100,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Network Connection',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ensure the host machine is running the ControlX server and accessible on the local network.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: ipController,
                      decoration: const InputDecoration(
                        labelText: 'Target IP Address',
                        hintText: 'e.g. 192.168.1.100',
                        prefixIcon: Icon(Icons.router),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: codeController,
                      decoration: const InputDecoration(
                        labelText: 'Pairing PIN',
                        hintText: 'Enter 6-digit code',
                        prefixIcon: Icon(Icons.key),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: onConnect,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      child: const Text('Connect to Device', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
