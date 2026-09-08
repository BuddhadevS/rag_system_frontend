import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/api_config.dart';
import '../../data/models.dart';
import '../../data/rag_api_client.dart';
import '../../domain/qa_history_store.dart';
import '../../state/document_detail_controller.dart';
import '../components/error_banner.dart';
import '../theme/app_theme.dart';

class DocumentDetailScreen extends StatelessWidget {
  const DocumentDetailScreen({super.key, required this.documentId});

  final int documentId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => DocumentDetailController(
        api: ctx.read<RagApiClient>(),
        history: ctx.read<QaHistoryStore>(),
        documentId: documentId,
      )..init(),
      child: const _WorkspaceBody(),
    );
  }
}

class _WorkspaceBody extends StatefulWidget {
  const _WorkspaceBody();

  @override
  State<_WorkspaceBody> createState() => _WorkspaceBodyState();
}

class _WorkspaceBodyState extends State<_WorkspaceBody> {
  final _questionCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  static const _suggestions = [
    'What is this document about?',
    'Summarize the key points',
    'What are the main requirements?',
    'Explain this in simple terms',
  ];

  @override
  void dispose() {
    _questionCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _ask([String? preset]) async {
    final vm = context.read<DocumentDetailController>();
    if (preset != null) {
      _questionCtrl.text = preset;
    }
    final q = _questionCtrl.text;
    await vm.ask(q);
    if (!mounted) return;
    if (vm.error == null) {
      _questionCtrl.clear();
      await Future<void>.delayed(const Duration(milliseconds: 80));
      if (_scrollCtrl.hasClients) {
        await _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  Future<void> _newDocument() async {
    final vm = context.read<DocumentDetailController>();
    if (vm.history.isNotEmpty) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Upload new document?'),
          content: const Text(
            'This will leave the current conversation. Your local Q&A history for this document stays saved.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
      if (ok != true || !mounted) return;
    }
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DocumentDetailController>();
    final doc = vm.document;
    final status = vm.liveStatus ?? doc?.status;

    if (vm.loading && doc == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (doc == null) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: DmCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  vm.error ?? 'Document not found',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Back to upload'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final ready = status == ProcessingStatus.completed;
    final failed = status == ProcessingStatus.failed;
    final processing = !ready && !failed;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: ListView(
          controller: _scrollCtrl,
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
          children: [
            _DocumentInfoCard(
              document: doc,
              status: status ?? doc.status,
              onNewDocument: _newDocument,
            ),
            const SizedBox(height: 16),
            if (vm.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ErrorBanner(
                  message: vm.error!,
                  onDismiss: vm.clearError,
                  onRetry: vm.asking ? null : () => _ask(),
                ),
              ),
            if (failed) ...[
              DmCard(
                color: AppColors.errorSoft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Document processing failed',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.error,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      vm.statusError ??
                          'Something went wrong while preparing your document.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                          ),
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Try another document'),
                    ),
                  ],
                ),
              ),
            ] else if (processing) ...[
              _ProcessingCard(status: status ?? doc.status),
            ] else ...[
              _ReadyBanner(filename: doc.filename),
              const SizedBox(height: 20),
              AnimatedOpacity(
                opacity: ready ? 1 : 0,
                duration: const Duration(milliseconds: 450),
                child: _QuestionSection(
                  controller: _questionCtrl,
                  asking: vm.asking,
                  enabled: vm.canAsk,
                  suggestions: _suggestions,
                  onAsk: () => _ask(),
                  onCancel: vm.cancelAsk,
                  onSuggestion: (s) => _ask(s),
                ),
              ),
              if (vm.asking) ...[
                const SizedBox(height: 16),
                const _ThinkingIndicator(),
              ],
              const SizedBox(height: 24),
              if (vm.history.isEmpty && !vm.asking)
                DmCard(
                  child: Column(
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          color: AppColors.purple, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        'Your document is ready',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ask your first question to get started.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              else
                ...vm.history.map(
                  (turn) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _ConversationTurn(
                      turn: turn,
                      documentName: doc.filename,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DocumentInfoCard extends StatelessWidget {
  const _DocumentInfoCard({
    required this.document,
    required this.status,
    required this.onNewDocument,
  });

  final DocumentResponse document;
  final ProcessingStatus status;
  final VoidCallback onNewDocument;

  @override
  Widget build(BuildContext context) {
    return DmCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.indigo, AppColors.purple],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.description_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.filename,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  status.label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onNewDocument,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Upload New Document'),
          ),
        ],
      ),
    );
  }
}

class _ProcessingCard extends StatelessWidget {
  const _ProcessingCard({required this.status});

  final ProcessingStatus status;

  @override
  Widget build(BuildContext context) {
    final step = switch (status) {
      ProcessingStatus.pending => 1,
      ProcessingStatus.processing => 2,
      _ => 3,
    };

    return DmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preparing your document...',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Extracting text, creating chunks and indexing for search.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 22),
          _Step(done: step >= 1, active: step == 1, label: 'Document uploaded'),
          _Step(done: step >= 2, active: step == 2, label: 'Text extracted'),
          _Step(
            done: step >= 3,
            active: step == 3,
            label: 'Creating embeddings / index',
          ),
          _Step(
            done: false,
            active: false,
            label: 'Preparing document for Q&A',
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.done,
    required this.active,
    required this.label,
  });

  final bool done;
  final bool active;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (done)
            const Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 20)
          else if (active)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.line, width: 2),
              ),
            ),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: done || active ? AppColors.ink : AppColors.inkSoft,
                  fontWeight:
                      active ? FontWeight.w700 : FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _ReadyBanner extends StatelessWidget {
  const _ReadyBanner({required this.filename});

  final String filename;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: DmCard(
        color: AppColors.successSoft,
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Document ready',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.success,
                        ),
                  ),
                  Text(
                    '$filename is ready for questions.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.success,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionSection extends StatelessWidget {
  const _QuestionSection({
    required this.controller,
    required this.asking,
    required this.enabled,
    required this.suggestions,
    required this.onAsk,
    required this.onCancel,
    required this.onSuggestion,
  });

  final TextEditingController controller;
  final bool asking;
  final bool enabled;
  final List<String> suggestions;
  final VoidCallback onAsk;
  final VoidCallback onCancel;
  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    return DmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ask anything about your document',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask a question and the AI will answer using the information from your document.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          TextField(
            controller: controller,
            enabled: enabled || asking,
            minLines: 3,
            maxLines: 5,
            maxLength: ApiConfig.maxQuestionLength,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) {
              if (enabled) onAsk();
            },
            decoration: const InputDecoration(
              hintText: 'Ask a question about your document...',
              counterText: '',
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: asking
                ? OutlinedButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: const Text('Cancel'),
                  )
                : FilledButton.icon(
                    onPressed: enabled ? onAsk : null,
                    icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                    label: const Text('Ask AI →'),
                  ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in suggestions)
                ActionChip(
                  label: Text(s),
                  onPressed: enabled ? () => onSuggestion(s) : null,
                  backgroundColor: AppColors.bg,
                  side: const BorderSide(color: AppColors.line),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThinkingIndicator extends StatelessWidget {
  const _ThinkingIndicator();

  @override
  Widget build(BuildContext context) {
    return DmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(
                'Thinking...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Searching the document and generating an answer.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _ThinkStep('Searching document'),
          _ThinkStep('Finding relevant sections'),
          _ThinkStep('Generating answer', last: true),
        ],
      ),
    );
  }
}

class _ThinkStep extends StatelessWidget {
  const _ThinkStep(this.label, {this.last = false});

  final String label;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 8),
      child: Row(
        children: [
          const Icon(Icons.arrow_downward_rounded,
              size: 14, color: AppColors.purple),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ConversationTurn extends StatelessWidget {
  const _ConversationTurn({
    required this.turn,
    required this.documentName,
  });

  final QaTurn turn;
  final String documentName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.indigoSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    turn.question,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.jm().format(turn.askedAt.toLocal()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _AnswerCard(turn: turn),
        const SizedBox(height: 12),
        _SourceSection(
          sources: turn.sources,
          documentName: documentName,
        ),
      ],
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({required this.turn});

  final QaTurn turn;

  @override
  Widget build(BuildContext context) {
    return DmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.indigo, AppColors.purple],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'DocuMind AI',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Copy',
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: turn.answer));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Answer copied')),
                    );
                  }
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SelectableText(
            turn.answer,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.ink,
                  height: 1.55,
                  fontSize: 15.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _SourceSection extends StatelessWidget {
  const _SourceSection({
    required this.sources,
    required this.documentName,
  });

  final List<SourceDocumentResponse> sources;
  final String documentName;

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) {
      return DmCard(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No chunks passed the similarity threshold — try a more specific question.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sources from your document',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        ...sources.asMap().entries.map((e) {
          final i = e.key + 1;
          final s = e.value;
          final pct = (s.score * 100).clamp(0, 100).toStringAsFixed(0);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 14),
              childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.line),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.line),
              ),
              backgroundColor: AppColors.paper,
              collapsedBackgroundColor: AppColors.paper,
              title: Text(
                'Source $i',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                '$documentName · Chunk #${s.chunkIndex} · Relevance: $pct%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    s.excerpt,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.ink,
                        ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
