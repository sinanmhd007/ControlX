import 'package:controlx/features/control/presentation/bloc/control_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'glass_card.dart';

class BuiltActionCard extends StatelessWidget {
  const BuiltActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.endpointAction,
    required this.deviceIp, 
  });

  final String title;
  final IconData icon;
  final Color color;
  final String endpointAction;
  final String deviceIp;

  void _sendCommand(BuildContext context) {
    context.read<ControlBloc>().add(
      SendCommandEvent(deviceIp, endpointAction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _sendCommand(context), // ✅ pass context
      borderRadius: BorderRadius.circular(24),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}