import 'package:flutter/material.dart';
import '../../../../control/presentation/widgets/built_action_card.dart';
import '../../../../control/presentation/widgets/built_stat_card.dart';
import '../../../../control/presentation/widgets/glass_card.dart';
import '../../bloc/control_bloc.dart';

class DashboardMobile extends StatelessWidget {
  final String deviceIp;
  final ControlState state;
  final bool isLoading;
  final bool isConnected;
  final String cpu;
  final String ram;
  final String os;

  const DashboardMobile({
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
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassCard(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isConnected
                        ? Colors.greenAccent
                        : (isLoading
                              ? Colors.orangeAccent
                              : Colors.redAccent),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  isConnected
                      ? 'Connected'
                      : (isLoading ? 'Connecting...' : 'Disconnected'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  deviceIp,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'System Monitoring',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (state is ControlLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (state is ControlError)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Device unreachable.'),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: BuiltStatCard(
                    title: 'CPU',
                    value: cpu,
                    icon: Icons.memory,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BuiltStatCard(
                    title: 'RAM',
                    value: ram,
                    icon: Icons.storage,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BuiltStatCard(
                    title: 'OS',
                    value: os,
                    icon: Icons.computer,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 32),

          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
