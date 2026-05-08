import 'package:flutter/material.dart';
import '../../../../control/presentation/widgets/built_action_card.dart';
import '../../../../control/presentation/widgets/built_stat_card.dart';
import '../../../../control/presentation/widgets/glass_card.dart';
import '../../bloc/control_bloc.dart';

class DashboardWeb extends StatelessWidget {
  final String deviceIp;
  final ControlState state;
  final bool isLoading;
  final bool isConnected;
  final String cpu;
  final String ram;
  final String os;

  const DashboardWeb({
    super.key,
    required this.deviceIp,
    required this.state,
    required this.isLoading,
    required this.isConnected,
    required this.cpu,
    required this.ram,
    required this.os,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Panel - System Info & Status
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    GlassCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isConnected
                                  ? Colors.greenAccent.withValues(alpha: 0.2)
                                  : (isLoading
                                        ? Colors.orangeAccent.withValues(alpha: 0.2)
                                        : Colors.redAccent.withValues(alpha: 0.2)),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.wifi_tethering,
                              size: 32,
                              color: isConnected
                                  ? Colors.greenAccent
                                  : (isLoading
                                        ? Colors.orangeAccent
                                        : Colors.redAccent),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isConnected
                                ? 'Connected'
                                : (isLoading ? 'Connecting...' : 'Disconnected'),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            deviceIp,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state is ControlLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (state is ControlError)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Text('Device unreachable.'),
                        ),
                      )
                    else
                      Column(
                        children: [
                          BuiltStatCard(
                            title: 'CPU',
                            value: cpu,
                            icon: Icons.memory,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 16),
                          BuiltStatCard(
                            title: 'RAM',
                            value: ram,
                            icon: Icons.storage,
                            color: Colors.purple,
                          ),
                          const SizedBox(height: 16),
                          BuiltStatCard(
                            title: 'OS',
                            value: os,
                            icon: Icons.computer,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              // Right Panel - Quick Actions
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 1.2,
                      children: [
                        BuiltActionCard(
                          title: 'Open Chrome',
                          icon: Icons.open_in_browser,
                          color: Colors.green,
                          endpointAction: 'open_chrome',
                          deviceIp: deviceIp,
                        ),
                        BuiltActionCard(
                          title: 'Open VS Code',
                          icon: Icons.code,
                          color: Colors.blueAccent,
                          endpointAction: 'open_vscode',
                          deviceIp: deviceIp,
                        ),
                        BuiltActionCard(
                          title: 'Open Terminal',
                          icon: Icons.terminal,
                          color: Colors.grey,
                          endpointAction: 'open_cmd',
                          deviceIp: deviceIp,
                        ),
                        BuiltActionCard(
                          title: 'File Explorer',
                          icon: Icons.storage,
                          color: Colors.pink,
                          endpointAction: 'open_explorer',
                          deviceIp: deviceIp,
                        ),
                        BuiltActionCard(
                          title: 'Restart',
                          icon: Icons.restart_alt,
                          color: Colors.amber,
                          endpointAction: 'restart',
                          deviceIp: deviceIp,
                        ),
                        BuiltActionCard(
                          title: 'Shutdown',
                          icon: Icons.power_settings_new,
                          color: Colors.redAccent,
                          endpointAction: 'shutdown',
                          deviceIp: deviceIp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
