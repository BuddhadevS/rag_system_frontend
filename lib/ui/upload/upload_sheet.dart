import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/file_validator.dart';
import '../../state/documents_controller.dart';
import '../theme/app_theme.dart';

Future<void> showUploadSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const UploadSheet(),
  );
}

class UploadSheet extends StatefulWidget {
  const UploadSheet({super.key});

  @override
  State<UploadSheet> createState() => _UploadSheetState();
}

class _UploadSheetState extends State<UploadSheet> {
  PlatformFile? _file;
  String? _localError;
  bool _busy = false;

  Future<void> _pick() async {
    setState(() => _localError = null);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final validation = FileValidator.validate(
      filename: file.name,
      mimeType: FileValidator.guessContentType(file.name),
      sizeBytes: file.size,
    );
    if (!validation.isValid) {
      setState(() {
        _file = null;
        _localError = validation.error;
      });
      return;
    }
    setState(() {
      _file = file;
      _localError = null;
    });
  }

  Future<void> _submit() async {
    final file = _file;
    if (file == null) {
      setState(() => _localError = 'Choose a PDF, PNG, or JPEG first.');
      return;
    }
    setState(() => _busy = true);
    final docs = context.read<DocumentsController>();
    final id = await docs.uploadPickedFile(file);
    if (!mounted) return;
    setState(() => _busy = false);
    if (id != null) {
      Navigator.of(context).pop();
      context.go('/documents/$id');
    } else {
      setState(() => _localError = docs.error ?? 'Upload failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Material(
            color: AppColors.paper,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.line,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Upload document',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'PDF or image · max 50 MB · processed asynchronously',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 22),
                  InkWell(
                    onTap: _busy ? null : _pick,
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _file == null
                              ? AppColors.line
                              : AppColors.indigo.withValues(alpha: 0.55),
                          width: 1.4,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.mist,
                            AppColors.indigoSoft.withValues(alpha: 0.35),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _file == null
                                ? Icons.cloud_upload_rounded
                                : Icons.description_rounded,
                            size: 36,
                            color: AppColors.indigo,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _file?.name ?? 'Click to choose a file',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.ink),
                          ),
                          if (_file != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              _formatSize(_file!.size),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (_localError != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      _localError!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.rose,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              _busy ? null : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _busy ? null : _submit,
                          child: _busy
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Upload'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
