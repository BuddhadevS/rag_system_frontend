import 'models.dart';

class ApiException implements Exception {
  ApiException({
    required this.statusCode,
    this.error,
    this.rawBody,
    this.cause,
  });

  final int statusCode;
  final ErrorResponse? error;
  final String? rawBody;
  final Object? cause;

  String get message {
    if (error != null) return error!.displayMessage;
    if (rawBody != null && rawBody!.trim().isNotEmpty) return rawBody!;
    if (cause != null) return cause.toString();
    return 'Request failed ($statusCode)';
  }

  String get userMessage {
    switch (statusCode) {
      case 0:
        return 'Cannot reach the API. Is the backend running at the configured URL?';
      case 400:
        return message;
      case 404:
        return 'Document not found.';
      case 409:
        return 'Document is still processing. Wait until status is Ready.';
      case 422:
        return message;
      case 502:
        return 'Upstream AI/search failed — retry in a moment.';
      case 503:
        return 'Server is busy — try again shortly.';
      case 500:
        return message.isNotEmpty ? message : 'Unexpected server error.';
      default:
        return message;
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $userMessage';
}
