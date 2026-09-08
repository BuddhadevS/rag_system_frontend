import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.errorMessage});

  final ProcessingStatus status;
  final String? errorMessage;

  Color get _bg => switch (status) {
        ProcessingStatus.pending => const Color(0xFFFEF3C7),
        ProcessingStatus.processing => AppColors.indigoSoft,
        ProcessingStatus.completed => AppColors.successSoft,
        ProcessingStatus.failed => AppColors.errorSoft,
      };

  Color get _fg => switch (status) {
        ProcessingStatus.pending => AppColors.amber,
        ProcessingStatus.processing => AppColors.indigoDeep,
        ProcessingStatus.completed => AppColors.success,
        ProcessingStatus.failed => AppColors.error,
      };

  @override
  Widget build(BuildContext context) {
    final spinning = status == ProcessingStatus.processing ||
        status == ProcessingStatus.pending;

    return Tooltip(
      message: errorMessage?.isNotEmpty == true ? errorMessage! : status.label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (spinning) ...[
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 1.8, color: _fg),
              ),
              const SizedBox(width: 8),
            ] else ...[
              Icon(
                status == ProcessingStatus.completed
                    ? Icons.check_circle_rounded
                    : Icons.error_rounded,
                size: 14,
                color: _fg,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              status.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _fg,
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
