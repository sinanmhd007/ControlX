import 'package:flutter/material.dart';
import '../../widgets/glass_card.dart';

class ConnectMobile extends StatelessWidget {
  final TextEditingController ipController;
  final TextEditingController codeController;
  final VoidCallback onConnect;

  const ConnectMobile({
    super.key,
    required this.ipController,
    required this.codeController,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassCard(
            child: Column(
              children: [
                const Icon(
                  Icons.wifi_tethering,
                  size: 64,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                Text(
                  'Local Network Connection',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ensure your laptop and phone are on the same Wi-Fi network.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: ipController,
            decoration: const InputDecoration(
              labelText: 'Laptop IP Address',
              hintText: 'e.g. 192.168.1.100',
              prefixIcon: Icon(Icons.router),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: codeController,
            decoration: const InputDecoration(
              labelText: 'Pairing Code',
              hintText: 'Enter 6-digit code',
              prefixIcon: Icon(Icons.key),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: onConnect,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }
}
