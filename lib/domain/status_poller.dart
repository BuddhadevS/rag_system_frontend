import 'dart:async';

import '../data/models.dart';
import '../data/rag_api_client.dart';

/// Polls document status with exponential backoff: 1s → 2s → 3s → 4s → 5s (cap).
class StatusPoller {
  StatusPoller({
    required this.api,
    required this.documentId,
    required this.onUpdate,
  });

  final RagApiClient api;
  final int documentId;
  final void Function(DocumentStatusResponse status) onUpdate;

  Timer? _timer;
  int _tick = 0;
  bool _stopped = false;

  void start() {
    _stopped = false;
    _schedule(immediate: true);
  }

  void stop() {
    _stopped = true;
    _timer?.cancel();
    _timer = null;
  }

  void _schedule({bool immediate = false}) {
    if (_stopped) return;
    _timer?.cancel();
    final delay = immediate ? Duration.zero : _delayFor(_tick);
    _timer = Timer(delay, _tickOnce);
  }

  Duration _delayFor(int tick) {
    final seconds = (tick + 1).clamp(1, 5);
    return Duration(seconds: seconds);
  }

  Future<void> _tickOnce() async {
    if (_stopped) return;
    try {
      final status = await api.getStatus(documentId);
      if (_stopped) return;
      onUpdate(status);
      if (status.status.isTerminal) {
        stop();
        return;
      }
      _tick++;
      _schedule();
    } catch (_) {
      if (_stopped) return;
      _tick++;
      _schedule();
    }
  }
}
