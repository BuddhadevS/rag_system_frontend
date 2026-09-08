import '../config/api_config.dart';

class FileValidationResult {
  const FileValidationResult._({this.error});

  final String? error;

  bool get isValid => error == null;

  static const FileValidationResult ok = FileValidationResult._();

  factory FileValidationResult.fail(String message) =>
      FileValidationResult._(error: message);
}

class FileValidator {
  FileValidator._();

  static const allowedMimes = {
    'application/pdf',
    'image/png',
    'image/jpeg',
    'image/jpg',
  };

  static const allowedExtensions = {'.pdf', '.png', '.jpg', '.jpeg'};

  static FileValidationResult validate({
    required String filename,
    required String? mimeType,
    required int sizeBytes,
  }) {
    if (sizeBytes <= 0) {
      return FileValidationResult.fail('File is empty');
    }
    if (sizeBytes > ApiConfig.maxFileBytes) {
      return FileValidationResult.fail('File exceeds 50 MB');
    }

    final lower = filename.toLowerCase();
    final hasExt = allowedExtensions.any(lower.endsWith);
    final mime = (mimeType ?? '').toLowerCase().trim();
    final mimeOk = mime.isEmpty || allowedMimes.contains(mime);

    if (!hasExt && !mimeOk) {
      return FileValidationResult.fail(
        'Unsupported type — use PDF, PNG, or JPEG',
      );
    }
    if (mime.isNotEmpty && !allowedMimes.contains(mime) && !hasExt) {
      return FileValidationResult.fail(
        'Unsupported type — use PDF, PNG, or JPEG',
      );
    }
    if (!hasExt) {
      return FileValidationResult.fail(
        'Unsupported type — use PDF, PNG, or JPEG',
      );
    }

    return FileValidationResult.ok;
  }

  static String guessContentType(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return 'image/jpeg';
    }
    return 'application/octet-stream';
  }
}
