import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import '../widgets/glass_card.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final _ipController = TextEditingController(text: '10.0.2.2'); // Localhost for emulator
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _ipController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Device'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassCard(
              child: Column(
                children: [
                  const Icon(Icons.wifi_tethering, size: 64, color: Colors.blueAccent),
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
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'Laptop IP Address',
                hintText: 'e.g. 192.168.1.100',
                prefixIcon: Icon(Icons.router),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Pairing Code',
                hintText: 'Enter 6-digit code (Leave empty if already paired)',
                prefixIcon: Icon(Icons.key),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final ip = _ipController.text.trim();
                final pin = _codeController.text.trim();
                
                if (ip.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an IP address')),
                  );
                  return;
                }
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => DashboardPage(deviceIp: ip, devicePin: pin)),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
