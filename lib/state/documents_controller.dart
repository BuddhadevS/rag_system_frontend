import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import '../data/api_exception.dart';
import '../data/file_validator.dart';
import '../data/models.dart';
import '../data/rag_api_client.dart';
import '../domain/qa_history_store.dart';

class DocumentsController extends ChangeNotifier {
  DocumentsController(this._api, this._history);

  final RagApiClient _api;
  final QaHistoryStore _history;

  DocumentPage? page;
  bool loading = false;
  bool uploading = false;
  String? error;
  String? banner;
  int currentPage = 0;

  Future<void> load({int? pageIndex}) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final p = pageIndex ?? currentPage;
      page = await _api.listDocuments(page: p, size: ApiConfig.pageSize);
      currentPage = page!.number;
    } on ApiException catch (e) {
      error = e.userMessage;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> nextPage() async {
    if (page?.hasNext != true) return;
    await load(pageIndex: currentPage + 1);
  }

  Future<void> previousPage() async {
    if (page?.hasPrevious != true) return;
    await load(pageIndex: currentPage - 1);
  }

  Future<int?> uploadPickedFile(PlatformFile file) async {
    final bytes = file.bytes;
    if (bytes == null) {
      error = 'Could not read file bytes in this environment.';
      notifyListeners();
      return null;
    }

    final mime = file.extension == null
        ? null
        : FileValidator.guessContentType(file.name);
    final validation = FileValidator.validate(
      filename: file.name,
      mimeType: mime,
      sizeBytes: bytes.length,
    );
    if (!validation.isValid) {
      error = validation.error;
      notifyListeners();
      return null;
    }

    uploading = true;
    error = null;
    banner = null;
    notifyListeners();

    try {
      final contentType = FileValidator.guessContentType(file.name);
      final result = await _api.uploadDocument(
        filename: file.name,
        contentType: contentType,
        bytes: bytes,
      );
      banner = result.message;
      await load(pageIndex: 0);
      return result.documentId;
    } on ApiException catch (e) {
      error = e.userMessage;
      return null;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteDocument(int id) async {
    try {
      await _api.deleteDocument(id);
      await _history.clear(id);
      banner = 'Document deleted.';
      await load(pageIndex: currentPage);
      return true;
    } on ApiException catch (e) {
      error = e.userMessage;
      notifyListeners();
      return false;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    error = null;
    banner = null;
    notifyListeners();
  }
}
