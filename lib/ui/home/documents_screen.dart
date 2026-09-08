import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/file_validator.dart';
import '../../data/models.dart';
import '../../state/documents_controller.dart';
import '../components/status_chip.dart';
import '../theme/app_theme.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  PlatformFile? _selected;
  String? _localError;
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentsController>().load();
    });
  }

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
        _selected = null;
        _localError = validation.error;
      });
      return;
    }
    setState(() {
      _selected = file;
      _localError = null;
    });
  }

  void _clearSelection() {
    setState(() {
      _selected = null;
      _localError = null;
    });
  }

  Future<void> _upload() async {
    final file = _selected;
    if (file == null) return;
    final docs = context.read<DocumentsController>();
    final id = await docs.uploadPickedFile(file);
    if (!mounted) return;
    if (id != null) {
      context.go('/documents/$id');
    } else {
      setState(() => _localError = docs.error ?? 'Unable to upload document');
    }
  }

  @override
  Widget build(BuildContext context) {
    final docs = context.watch<DocumentsController>();
    final page = docs.page;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1120),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          children: [
            DmCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload your document',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload a document and ask questions about its content using AI.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  if (_selected == null)
                    _DropZone(
                      hover: _hover,
                      onHover: (v) => setState(() => _hover = v),
                      onTap: docs.uploading ? null : _pick,
                    )
                  else
                    _SelectedFileCard(
                      file: _selected!,
                      uploading: docs.uploading,
                      onRemove: docs.uploading ? null : _clearSelection,
                    ),
                  if (_localError != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      _localError!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: _selected == null || docs.uploading
                            ? null
                            : _upload,
                        icon: docs.uploading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.cloud_upload_rounded, size: 18),
                        label: Text(
                          docs.uploading
                              ? 'Processing document...'
                              : 'Upload & Process',
                        ),
                      ),
                      OutlinedButton(
                        onPressed: docs.uploading || _selected == null
                            ? null
                            : _clearSelection,
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Text(
                  'Recent documents',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const Spacer(),
                if (docs.loading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            if (docs.loading && page == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (page == null || page.content.isEmpty)
              DmCard(
                child: Column(
                  children: [
                    const Icon(Icons.description_outlined,
                        size: 40, color: AppColors.indigo),
                    const SizedBox(height: 12),
                    Text(
                      'Your document is waiting',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Upload a document to start asking questions.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...page.content.map(
                (doc) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RecentDocTile(
                    document: doc,
                    onOpen: () => context.go('/documents/${doc.id}'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DropZone extends StatelessWidget {
  const _DropZone({
    required this.hover,
    required this.onHover,
    required this.onTap,
  });

  final bool hover;
  final ValueChanged<bool> onHover;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
        decoration: BoxDecoration(
          color: hover ? AppColors.indigoSoft.withValues(alpha: 0.55) : AppColors.bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hover ? AppColors.indigo : AppColors.line,
            width: hover ? 1.8 : 1.4,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              AnimatedScale(
                scale: hover ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.paper,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: const Icon(
                    Icons.upload_file_rounded,
                    color: AppColors.indigo,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Drag & drop your document here',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'or click to browse files',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              Text(
                'PDF, PNG, JPEG  ·  Maximum size: 50 MB',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedFileCard extends StatelessWidget {
  const _SelectedFileCard({
    required this.file,
    required this.uploading,
    this.onRemove,
  });

  final PlatformFile file;
  final bool uploading;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final ext = (file.extension ?? '').toUpperCase();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.indigoSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description_rounded,
                    color: AppColors.indigo),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$ext · ${_formatSize(file.size)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.inkSoft,
                ),
            ],
          ),
          if (uploading) ...[
            const SizedBox(height: 14),
            Text(
              'Uploading...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.indigoDeep,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            const LinearProgressIndicator(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              minHeight: 6,
              color: AppColors.indigo,
              backgroundColor: AppColors.indigoSoft,
            ),
          ],
        ],
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

class _RecentDocTile extends StatelessWidget {
  const _RecentDocTile({required this.document, required this.onOpen});

  final DocumentResponse document;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return DmCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.indigoSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                document.contentType.contains('pdf')
                    ? Icons.picture_as_pdf_rounded
                    : Icons.image_rounded,
                color: AppColors.indigo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                document.filename,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            StatusChip(status: document.status),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.inkSoft),
          ],
        ),
      ),
    );
  }
}
