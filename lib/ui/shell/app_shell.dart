import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../state/documents_controller.dart';
import '../../state/health_controller.dart';
import '../components/error_banner.dart';
import '../theme/app_theme.dart';
import '../upload/upload_sheet.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final docs = context.watch<DocumentsController>();

    return AtmosphereBackground(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const _AppHeader(),
              if (docs.error != null || docs.banner != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1120),
                      child: ErrorBanner(
                        message: docs.error ?? docs.banner!,
                        tone: docs.error != null
                            ? BannerTone.error
                            : BannerTone.success,
                        onDismiss: docs.clearMessages,
                      ),
                    ),
                  ),
                ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    final health = context.watch<HealthController>();
    final docs = context.watch<DocumentsController>();
    final online = health.hasChecked && health.isUp;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.go('/'),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.indigo, AppColors.purple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DocuMind',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          'AI-powered Document Q&A',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: !health.hasChecked
                            ? AppColors.inkSoft.withValues(alpha: 0.4)
                            : online
                                ? AppColors.success
                                : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      !health.hasChecked
                          ? 'Checking…'
                          : online
                              ? 'AI Online'
                              : 'AI Offline',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 12,
                            color: AppColors.inkSoft,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: docs.uploading
                    ? null
                    : () => showUploadSheet(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('New document'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
