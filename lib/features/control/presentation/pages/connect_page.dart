import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/responsive_layout.dart';
import 'dashboard_page.dart';
import 'mobile/connect_mobile.dart';
import 'web/connect_web.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final _ipController = TextEditingController(
    text: '192.168.1.0',
  ); // Localhost for emulator
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _ipController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _onConnect() {
    final ip = _ipController.text.trim();
    final pin = _codeController.text.trim();

    if (ip.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an IP address')),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DashboardPage(deviceIp: ip, devicePin: pin),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Device'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ResponsiveLayout(
        mobileBody: ConnectMobile(
          ipController: _ipController,
          codeController: _codeController,
          onConnect: _onConnect,
        ),
        webBody: ConnectWeb(
          ipController: _ipController,
          codeController: _codeController,
          onConnect: _onConnect,
        ),
      ),
    );
  }
}
