import 'package:controlx/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/responsive_layout.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/control_bloc.dart';
import 'mobile/dashboard_mobile.dart';
import 'web/dashboard_web.dart';

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
            return;
            
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

          return ResponsiveLayout(
            mobileBody: DashboardMobile(
              deviceIp: widget.deviceIp,
              state: state,
              isLoading: isLoading,
              isConnected: isConnected,
              cpu: cpu,
              ram: ram,
              os: os,
            ),
            webBody: DashboardWeb(
              deviceIp: widget.deviceIp,
              state: state,
              isLoading: isLoading,
              isConnected: isConnected,
              cpu: cpu,
              ram: ram,
              os: os,
            ),
          );
        },
      ),
    );
  }
}
