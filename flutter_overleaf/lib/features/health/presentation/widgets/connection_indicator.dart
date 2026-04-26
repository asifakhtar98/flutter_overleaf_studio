import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_overleaf/core/theme/latex_theme.dart';
import 'package:flutter_overleaf/features/health/presentation/bloc/health_bloc.dart';
import 'package:flutter_overleaf/features/health/presentation/bloc/health_event.dart';
import 'package:flutter_overleaf/features/health/presentation/bloc/health_state.dart';

/// Compact connection status indicator for the toolbar.
///
/// Shows a colored dot + label. Tap while disconnected to retry.
class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthBloc, HealthState>(
      builder: (context, state) {
        return switch (state) {
          HealthUnknown() || HealthChecking() => _buildIndicator(
              context,
              color: LatexTheme.textSecondary,
              label: 'Checking…',
              pulse: true,
            ),
          HealthConnected(:final status) => Tooltip(
              message:
                  'TeX Live ${status.texliveVersion}\n'
                  'Uptime: ${_formatUptime(status.uptimeSeconds)}',
              waitDuration: const Duration(milliseconds: 400),
              child: _buildIndicator(
                context,
                color: LatexTheme.success,
                label: 'Connected',
              ),
            ),
          HealthDisconnected(:final message) => Tooltip(
              message: 'Tap to retry\n$message',
              waitDuration: const Duration(milliseconds: 200),
              child: InkWell(
                onTap: () => context
                    .read<HealthBloc>()
                    .add(const HealthEvent.checkRequested()),
                borderRadius: BorderRadius.circular(4),
                child: _buildIndicator(
                  context,
                  color: LatexTheme.error,
                  label: 'Offline',
                ),
              ),
            ),
        };
      },
    );
  }

  Widget _buildIndicator(
    BuildContext context, {
    required Color color,
    required String label,
    bool pulse = false,
  }) {
    final dot = Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulse)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.3, end: 1),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) =>
                  Opacity(opacity: value, child: child),
              onEnd: () {},
              child: dot,
            )
          else
            dot,
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }

  String _formatUptime(double seconds) {
    final duration = Duration(seconds: seconds.round());
    if (duration.inDays > 0) return '${duration.inDays}d ${duration.inHours % 24}h';
    if (duration.inHours > 0) return '${duration.inHours}h ${duration.inMinutes % 60}m';
    return '${duration.inMinutes}m';
  }
}
