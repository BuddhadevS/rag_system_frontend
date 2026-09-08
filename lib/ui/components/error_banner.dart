import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.onRetry,
    this.tone = BannerTone.error,
  });

  final String message;
  final VoidCallback? onDismiss;
  final VoidCallback? onRetry;
  final BannerTone tone;

  @override
  Widget build(BuildContext context) {
    final bg = switch (tone) {
      BannerTone.error => AppColors.errorSoft,
      BannerTone.info => AppColors.indigoSoft,
      BannerTone.success => AppColors.successSoft,
    };
    final fg = switch (tone) {
      BannerTone.error => AppColors.error,
      BannerTone.info => AppColors.indigoDeep,
      BannerTone.success => AppColors.success,
    };
    final icon = switch (tone) {
      BannerTone.error => Icons.error_outline_rounded,
      BannerTone.info => Icons.info_outline_rounded,
      BannerTone.success => Icons.check_circle_outline_rounded,
    };

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: fg, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text('Retry', style: TextStyle(color: fg)),
              ),
            if (onDismiss != null)
              IconButton(
                onPressed: onDismiss,
                icon: Icon(Icons.close_rounded, color: fg, size: 18),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}

enum BannerTone { error, info, success }
