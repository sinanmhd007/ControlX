import 'package:controlx/features/auth/presentation/pages/login_page.dart';
import 'package:controlx/features/control/presentation/widgets/built_action_card.dart';
import 'package:controlx/features/control/presentation/widgets/built_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/control_bloc.dart';
import '../widgets/glass_card.dart';

class DashboardPage extends StatefulWidget {
  final String deviceIp;
  final String devicePin;
  const DashboardPage({super.key, required this.deviceIp, this.devicePin = ''});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<ControlBloc>().add(
      ConnectDeviceEvent(widget.deviceIp, widget.devicePin),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Laptop'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ControlBloc>().add(
                RefreshSystemInfoEvent(widget.deviceIp),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout & Disconnect',
            onPressed: () {
              context.read<ControlBloc>().add(DisconnectDeviceEvent());
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ControlBloc, ControlState>(
        listener: (context, state) {
          if (state is ControlConnected && state.lastMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.lastMessage!),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ControlError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ControlErrorCommandFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          bool isLoading =
              state is ControlInitial ||
              state is ControlLoading ||
              state is ControlCommandLoading;
          bool isConnected =
              state is ControlConnected ||
              state is ControlCommandLoading ||
              state is ControlErrorCommandFailed;

          String cpu = '...';
          String ram = '...';
          String os = '...';

          if (state is ControlConnected) {
            cpu = state.systemInfo.cpu;
            ram = state.systemInfo.ram;
            os = state.systemInfo.os;
          } else if (state is ControlCommandLoading) {
            cpu = state.previousInfo.cpu;
            ram = state.previousInfo.ram;
            os = state.previousInfo.os;
          } else if (state is ControlErrorCommandFailed) {
            cpu = state.systemInfo.cpu;
            ram = state.systemInfo.ram;
            os = state.systemInfo.os;
          }

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
                        widget.deviceIp,
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
                          deviceIp: widget.deviceIp,
                        ),
                        BuiltActionCard(
                          title: 'Open VS Code',
                          icon: Icons.code,
                          color: Colors.blueAccent,
                          endpointAction: 'open_vscode',
                          deviceIp: widget.deviceIp,
                        ),
                        BuiltActionCard(
                          title: 'Open Terminal',
                          icon: Icons.terminal,
                          color: Colors.grey,
                          endpointAction: 'open_cmd',
                          deviceIp: widget.deviceIp,
                        ),
                        BuiltActionCard(
                          title: 'File Explorer', 
                          icon: Icons.storage, 
                          color: Colors.pink, 
                          endpointAction: 'open_explorer', 
                          deviceIp: widget.deviceIp
                        ),
                       
                        BuiltActionCard(
                          title: 'Restart',
                          icon: Icons.restart_alt,
                          color: Colors.amber,
                          endpointAction: 'restart',
                          deviceIp: widget.deviceIp,
                        ),
                        BuiltActionCard(
                          title: 'Shutdown',
                          icon: Icons.power_settings_new,
                          color: Colors.redAccent,
                          endpointAction: 'shutdown',
                          deviceIp: widget.deviceIp,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
