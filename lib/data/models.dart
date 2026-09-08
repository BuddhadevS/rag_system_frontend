enum ProcessingStatus {
  pending,
  processing,
  completed,
  failed;

  static ProcessingStatus fromJson(String? value) {
    switch (value?.toUpperCase()) {
      case 'PENDING':
        return ProcessingStatus.pending;
      case 'PROCESSING':
        return ProcessingStatus.processing;
      case 'COMPLETED':
        return ProcessingStatus.completed;
      case 'FAILED':
        return ProcessingStatus.failed;
      default:
        return ProcessingStatus.pending;
    }
  }

  String get apiValue => name.toUpperCase();

  String get label => switch (this) {
        ProcessingStatus.pending => 'Pending',
        ProcessingStatus.processing => 'Processing',
        ProcessingStatus.completed => 'Ready',
        ProcessingStatus.failed => 'Failed',
      };

  bool get isTerminal =>
      this == ProcessingStatus.completed || this == ProcessingStatus.failed;

  bool get canAsk => this == ProcessingStatus.completed;
}

class DocumentUploadResponse {
  const DocumentUploadResponse({
    required this.documentId,
    required this.filename,
    required this.status,
    required this.message,
  });

  final int documentId;
  final String filename;
  final ProcessingStatus status;
  final String message;

  factory DocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    return DocumentUploadResponse(
      documentId: (json['documentId'] as num).toInt(),
      filename: json['filename'] as String? ?? '',
      status: ProcessingStatus.fromJson(json['status'] as String?),
      message: json['message'] as String? ?? '',
    );
  }
}

class DocumentStatusResponse {
  const DocumentStatusResponse({
    required this.documentId,
    required this.status,
    this.errorMessage,
    this.updatedAt,
  });

  final int documentId;
  final ProcessingStatus status;
  final String? errorMessage;
  final DateTime? updatedAt;

  factory DocumentStatusResponse.fromJson(Map<String, dynamic> json) {
    return DocumentStatusResponse(
      documentId: (json['documentId'] as num).toInt(),
      status: ProcessingStatus.fromJson(json['status'] as String?),
      errorMessage: json['errorMessage'] as String?,
      updatedAt: _parseDate(json['updatedAt']),
    );
  }
}

class DocumentResponse {
  const DocumentResponse({
    required this.id,
    required this.filename,
    required this.contentType,
    required this.fileSize,
    required this.status,
    this.createdAt,
  });

  final int id;
  final String filename;
  final String contentType;
  final int fileSize;
  final ProcessingStatus status;
  final DateTime? createdAt;

  factory DocumentResponse.fromJson(Map<String, dynamic> json) {
    return DocumentResponse(
      id: (json['id'] as num).toInt(),
      filename: json['filename'] as String? ?? '',
      contentType: json['contentType'] as String? ?? '',
      fileSize: (json['fileSize'] as num?)?.toInt() ?? 0,
      status: ProcessingStatus.fromJson(json['status'] as String?),
      createdAt: _parseDate(json['createdAt']),
    );
  }

  DocumentResponse copyWith({ProcessingStatus? status}) {
    return DocumentResponse(
      id: id,
      filename: filename,
      contentType: contentType,
      fileSize: fileSize,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

class DocumentPage {
  const DocumentPage({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
  });

  final List<DocumentResponse> content;
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;

  factory DocumentPage.fromJson(Map<String, dynamic> json) {
    final raw = json['content'];
    final list = raw is List
        ? raw
            .whereType<Map>()
            .map((e) => DocumentResponse.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <DocumentResponse>[];

    return DocumentPage(
      content: list,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? list.length,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toInt() ?? list.length,
      number: (json['number'] as num?)?.toInt() ?? 0,
    );
  }

  bool get hasNext => number + 1 < totalPages;
  bool get hasPrevious => number > 0;
}

class QuestionRequest {
  const QuestionRequest({required this.documentId, required this.question});

  final int documentId;
  final String question;

  Map<String, dynamic> toJson() => {
        'documentId': documentId,
        'question': question,
      };
}

class SourceDocumentResponse {
  const SourceDocumentResponse({
    required this.documentId,
    required this.chunkIndex,
    required this.excerpt,
    required this.score,
  });

  final int documentId;
  final int chunkIndex;
  final String excerpt;
  final double score;

  factory SourceDocumentResponse.fromJson(Map<String, dynamic> json) {
    return SourceDocumentResponse(
      documentId: (json['documentId'] as num?)?.toInt() ?? 0,
      chunkIndex: (json['chunkIndex'] as num?)?.toInt() ?? 0,
      excerpt: json['excerpt'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
    );
  }
}

class AnswerResponse {
  const AnswerResponse({
    required this.question,
    required this.answer,
    required this.sources,
  });

  final String question;
  final String answer;
  final List<SourceDocumentResponse> sources;

  factory AnswerResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['sources'];
    final sources = raw is List
        ? raw
            .whereType<Map>()
            .map((e) =>
                SourceDocumentResponse.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <SourceDocumentResponse>[];

    return AnswerResponse(
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      sources: sources,
    );
  }
}

class FieldError {
  const FieldError({required this.field, required this.message});

  final String field;
  final String message;

  factory FieldError.fromJson(Map<String, dynamic> json) {
    return FieldError(
      field: json['field'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}

class ErrorResponse {
  const ErrorResponse({
    this.timestamp,
    this.status,
    this.error,
    this.message,
    this.path,
    this.field,
    this.fields,
  });

  final String? timestamp;
  final int? status;
  final String? error;
  final String? message;
  final String? path;
  final String? field;
  final List<FieldError>? fields;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return ErrorResponse(
      timestamp: json['timestamp']?.toString(),
      status: (json['status'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      path: json['path'] as String?,
      field: json['field'] as String?,
      fields: rawFields is List
          ? rawFields
              .whereType<Map>()
              .map((e) => FieldError.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : null,
    );
  }

  String get displayMessage {
    if (message != null && message!.trim().isNotEmpty) return message!;
    if (error != null && error!.trim().isNotEmpty) return error!;
    return 'Something went wrong';
  }
}

class HealthResponse {
  const HealthResponse({required this.status, this.timestamp});

  final String status;
  final String? timestamp;

  bool get isUp => status.toUpperCase() == 'UP';

  factory HealthResponse.fromJson(Map<String, dynamic> json) {
    return HealthResponse(
      status: json['status']?.toString() ?? 'DOWN',
      timestamp: json['timestamp']?.toString(),
    );
  }
}

class QaTurn {
  const QaTurn({
    required this.question,
    required this.answer,
    required this.sources,
    required this.askedAt,
  });

  final String question;
  final String answer;
  final List<SourceDocumentResponse> sources;
  final DateTime askedAt;

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
        'sources': sources
            .map((s) => {
                  'documentId': s.documentId,
                  'chunkIndex': s.chunkIndex,
                  'excerpt': s.excerpt,
                  'score': s.score,
                })
            .toList(),
        'askedAt': askedAt.toIso8601String(),
      };

  factory QaTurn.fromJson(Map<String, dynamic> json) {
    final raw = json['sources'];
    return QaTurn(
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      sources: raw is List
          ? raw
              .whereType<Map>()
              .map((e) =>
                  SourceDocumentResponse.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      askedAt: DateTime.tryParse(json['askedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
