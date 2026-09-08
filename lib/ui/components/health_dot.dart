import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../state/health_controller.dart';
import '../theme/app_theme.dart';

class HealthDot extends StatelessWidget {
  const HealthDot({super.key});

  @override
  Widget build(BuildContext context) {
    final health = context.watch<HealthController>();
    final color = !health.hasChecked
        ? AppColors.inkSoft.withValues(alpha: 0.4)
        : health.isUp
            ? const Color(0xFF2F9E6B)
            : AppColors.rose;

    final label = !health.hasChecked
        ? 'Checking…'
        : health.isUp
            ? 'API UP'
            : 'API DOWN';

    final checked = health.lastChecked == null
        ? ''
        : ' · ${DateFormat.Hm().format(health.lastChecked!)}';

    return Semantics(
      label: 'Backend health $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.paper.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.line.withValues(alpha: 0.8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$label$checked',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 12,
                    color: AppColors.inkSoft,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
