import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../data/models.dart';
import '../theme/app_theme.dart';

class QaHistoryList extends StatelessWidget {
  const QaHistoryList({super.key, required this.turns});

  final List<QaTurn> turns;

  @override
  Widget build(BuildContext context) {
    if (turns.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Text(
          'Ask a question to see grounded answers and sources here.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.inkSoft.withValues(alpha: 0.75),
              ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: turns.length,
      separatorBuilder: (_, _) => const SizedBox(height: 18),
      itemBuilder: (context, index) => QaTurnCard(turn: turns[index]),
    );
  }
}

class QaTurnCard extends StatelessWidget {
  const QaTurnCard({super.key, required this.turn});

  final QaTurn turn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Section(
          label: 'Question',
          accent: AppColors.teal,
          child: Text(
            turn.question,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  height: 1.35,
                ),
          ),
        ),
        const SizedBox(height: 10),
        _Section(
          label: 'Answer',
          accent: AppColors.amber,
          child: Text(
            turn.answer,
            style: GoogleFonts.literata(
              fontSize: 16.5,
              height: 1.55,
              color: AppColors.ink,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _Section(
          label: 'Sources',
          accent: AppColors.inkSoft,
          child: turn.sources.isEmpty
              ? Text(
                  'No chunks passed the similarity threshold — try a more specific question.',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              : Column(
                  children: [
                    for (final source in turn.sources)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SourceRow(source: source),
                      ),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 4),
          child: Text(
            DateFormat.yMMMd().add_jm().format(turn.askedAt.toLocal()),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.inkSoft.withValues(alpha: 0.65),
                ),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.accent,
    required this.child,
  });

  final String label;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.paper.withValues(alpha: 0.9),
          border: Border.all(color: AppColors.line.withValues(alpha: 0.7)),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ColoredBox(color: accent, child: const SizedBox(width: 3.5)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: accent,
                              fontSize: 11,
                              letterSpacing: 1.1,
                            ),
                      ),
                      const SizedBox(height: 8),
                      child,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source});

  final SourceDocumentResponse source;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Chunk #${source.chunkIndex}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.teal,
                    ),
              ),
              const Spacer(),
              Text(
                'score ${source.score.toStringAsFixed(3)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            source.excerpt,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.ink,
                ),
          ),
        ],
      ),
    );
  }
}
