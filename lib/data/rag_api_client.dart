import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import 'api_exception.dart';
import 'dio_web_config_stub.dart'
    if (dart.library.html) 'dio_web_config_web.dart' as dio_web;
import 'models.dart';

class RagApiClient {
  RagApiClient({Dio? dio, String? baseUrl}) : _dio = dio ?? _createDio(baseUrl);

  final Dio _dio;

  static Dio _createDio(String? baseUrl) {
    final client = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.defaultReadTimeout,
        // Never set sendTimeout on BaseOptions — on web it is unsupported
        // and registers an upload listener that forces CORS preflight.
        headers: const {
          'Accept': 'application/json',
        },
        validateStatus: (_) => true,
      ),
    );
    // Spring already answers OPTIONS; mute Dio's noisy preflight notice.
    dio_web.configureWebDio(client);
    return client;
  }

  /// `sendTimeout` is unsupported / noisy on Flutter web (forces preflight).
  static Duration? get _sendTimeout =>
      kIsWeb ? null : ApiConfig.defaultReadTimeout;

  static Duration? get _querySendTimeout =>
      kIsWeb ? null : ApiConfig.connectTimeout;

  Future<HealthResponse> getHealth() async {
    final response = await _request(
      () => _dio.get<dynamic>('/health'),
    );
    return HealthResponse.fromJson(_asMap(response.data));
  }

  Future<DocumentUploadResponse> uploadDocument({
    required String filename,
    required String contentType,
    required List<int> bytes,
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
      ),
    });

    final response = await _request(
      () => _dio.post<dynamic>(
        '/documents/upload',
        data: form,
        options: Options(
          contentType: 'multipart/form-data',
          receiveTimeout: ApiConfig.defaultReadTimeout,
          sendTimeout: _sendTimeout,
        ),
      ),
      successCodes: const {202},
    );
    return DocumentUploadResponse.fromJson(_asMap(response.data));
  }

  Future<DocumentStatusResponse> getStatus(int documentId) async {
    final response = await _request(
      () => _dio.get<dynamic>('/documents/$documentId/status'),
    );
    return DocumentStatusResponse.fromJson(_asMap(response.data));
  }

  Future<DocumentResponse> getDocument(int documentId) async {
    final response = await _request(
      () => _dio.get<dynamic>('/documents/$documentId'),
    );
    return DocumentResponse.fromJson(_asMap(response.data));
  }

  Future<DocumentPage> listDocuments({
    int page = 0,
    int size = ApiConfig.pageSize,
    String? sort,
  }) async {
    final response = await _request(
      () => _dio.get<dynamic>(
        '/documents',
        queryParameters: {
          'page': page,
          'size': size,
          if (sort != null && sort.isNotEmpty) 'sort': sort,
        },
      ),
    );
    return DocumentPage.fromJson(_asMap(response.data));
  }

  Future<void> deleteDocument(int documentId) async {
    await _request(
      () => _dio.delete<dynamic>('/documents/$documentId'),
      successCodes: const {204},
    );
  }

  Future<AnswerResponse> ask({
    required int documentId,
    required String question,
    CancelToken? cancelToken,
  }) async {
    final response = await _request(
      () => _dio.post<dynamic>(
        '/query',
        data: QuestionRequest(documentId: documentId, question: question)
            .toJson(),
        cancelToken: cancelToken,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: ApiConfig.queryReadTimeout,
          sendTimeout: _querySendTimeout,
        ),
      ),
    );
    return AnswerResponse.fromJson(_asMap(response.data));
  }

  Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() call, {
    Set<int> successCodes = const {200},
  }) async {
    try {
      final response = await call();
      final code = response.statusCode ?? 0;
      if (successCodes.contains(code)) {
        return response;
      }
      throw _toApiException(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        rethrow;
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        throw ApiException(
          statusCode: 0,
          cause: e.message ?? e.error,
        );
      }
      if (e.response != null) {
        throw _toApiException(e.response!);
      }
      throw ApiException(statusCode: 0, cause: e.message ?? e);
    }
  }

  ApiException _toApiException(Response<dynamic> response) {
    ErrorResponse? parsed;
    String? raw;
    final data = response.data;
    if (data is Map) {
      parsed = ErrorResponse.fromJson(Map<String, dynamic>.from(data));
    } else if (data is String && data.isNotEmpty) {
      raw = data;
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          parsed = ErrorResponse.fromJson(Map<String, dynamic>.from(decoded));
        }
      } catch (_) {}
    }
    return ApiException(
      statusCode: response.statusCode ?? 500,
      error: parsed,
      rawBody: raw,
    );
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data == null) return <String, dynamic>{};
    throw ApiException(
      statusCode: 500,
      rawBody: 'Unexpected response shape: ${data.runtimeType}',
    );
  }
}
