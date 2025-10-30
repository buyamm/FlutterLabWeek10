import 'package:flutter/material.dart';
import '../models/hourly_point.dart';
import '../theme/app_theme.dart';

class HourlyStrip extends StatelessWidget {
  const HourlyStrip({super.key, required this.points});

  final List<HourlyPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surfaceContainer;

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: points.length,
        separatorBuilder:
            (_, __) => const SizedBox(width: AppTheme.elementSpacing),
        itemBuilder: (context, index) {
          final point = points[index];
          return Container(
            width: 90,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_formatTime(point.time), style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                // Icon bỏ vì HourlyPoint không có
                Text(
                  '${point.temperature.toStringAsFixed(1)}°C',
                  style: theme.textTheme.bodyMedium,
                ),
                // Bỏ Feels vì HourlyPoint không có apparentTemperature
              ],
            ),
          );
        },
      ),
    );
  }
}

String _formatTime(DateTime date) {
  final hours = date.hour.toString().padLeft(2, '0');
  final minutes = date.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}
