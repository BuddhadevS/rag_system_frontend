import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import '../data/api_exception.dart';
import '../data/models.dart';
import '../data/rag_api_client.dart';
import '../domain/qa_history_store.dart';
import '../domain/status_poller.dart';

class DocumentDetailController extends ChangeNotifier {
  DocumentDetailController({
    required RagApiClient api,
    required QaHistoryStore history,
    required this.documentId,
  })  : _api = api,
        _history = history;

  final RagApiClient _api;
  final QaHistoryStore _history;
  final int documentId;

  DocumentResponse? document;
  ProcessingStatus? liveStatus;
  String? statusError;
  List<QaTurn> history = const [];
  bool loading = true;
  bool asking = false;
  String? error;
  String? info;
  CancelToken? _askCancel;
  StatusPoller? _poller;

  bool get canAsk =>
      (liveStatus ?? document?.status)?.canAsk == true && !asking;

  Future<void> init() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      document = await _api.getDocument(documentId);
      liveStatus = document!.status;
      history = await _history.load(documentId);
      if (!document!.status.isTerminal) {
        _startPoller();
      }
    } on ApiException catch (e) {
      error = e.userMessage;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void _startPoller() {
    _poller?.stop();
    _poller = StatusPoller(
      api: _api,
      documentId: documentId,
      onUpdate: (status) {
        liveStatus = status.status;
        statusError = status.errorMessage;
        document = document?.copyWith(status: status.status);
        notifyListeners();
      },
    )..start();
  }

  Future<void> ask(String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty) {
      error = 'Question cannot be blank.';
      notifyListeners();
      return;
    }
    if (trimmed.length > ApiConfig.maxQuestionLength) {
      error = 'Question must be at most ${ApiConfig.maxQuestionLength} characters.';
      notifyListeners();
      return;
    }
    if (!canAsk) {
      error = 'Document must be Ready before asking.';
      notifyListeners();
      return;
    }

    asking = true;
    error = null;
    info = 'Generating answer… this can take up to a few minutes.';
    _askCancel = CancelToken();
    notifyListeners();

    try {
      final answer = await _api.ask(
        documentId: documentId,
        question: trimmed,
        cancelToken: _askCancel,
      );
      final turn = QaTurn(
        question: answer.question.isEmpty ? trimmed : answer.question,
        answer: answer.answer,
        sources: answer.sources,
        askedAt: DateTime.now(),
      );
      history = await _history.append(documentId, turn);
      if (answer.sources.isEmpty) {
        info =
            'No chunks passed the similarity threshold — try a more specific question.';
      } else {
        info = null;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        info = 'Request cancelled.';
      } else {
        error = e.message ?? e.toString();
      }
    } on ApiException catch (e) {
      error = e.userMessage;
      info = null;
    } catch (e) {
      error = e.toString();
      info = null;
    } finally {
      asking = false;
      _askCancel = null;
      notifyListeners();
    }
  }

  void cancelAsk() {
    _askCancel?.cancel('cancelled by user');
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _poller?.stop();
    _askCancel?.cancel('disposed');
    super.dispose();
  }
}
