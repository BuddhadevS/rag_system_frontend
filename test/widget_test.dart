import 'package:flutter_test/flutter_test.dart';
import 'package:rag_system/data/file_validator.dart';
import 'package:rag_system/data/models.dart';

void main() {
  group('FileValidator', () {
    test('rejects empty file', () {
      final result = FileValidator.validate(
        filename: 'doc.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 0,
      );
      expect(result.isValid, isFalse);
      expect(result.error, 'File is empty');
    });

    test('rejects oversized file', () {
      final result = FileValidator.validate(
        filename: 'doc.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 52428801,
      );
      expect(result.isValid, isFalse);
      expect(result.error, 'File exceeds 50 MB');
    });

    test('accepts pdf under limit', () {
      final result = FileValidator.validate(
        filename: 'doc.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 1024,
      );
      expect(result.isValid, isTrue);
    });

    test('rejects unsupported extension', () {
      final result = FileValidator.validate(
        filename: 'notes.txt',
        mimeType: 'text/plain',
        sizeBytes: 10,
      );
      expect(result.isValid, isFalse);
    });
  });

  group('models', () {
    test('AnswerResponse parses question above answer sources', () {
      final answer = AnswerResponse.fromJson({
        'question': 'What is this?',
        'answer': 'A sample.',
        'sources': [
          {
            'documentId': 1,
            'chunkIndex': 0,
            'excerpt': 'sample text',
            'score': 0.91,
          }
        ],
      });
      expect(answer.question, 'What is this?');
      expect(answer.answer, 'A sample.');
      expect(answer.sources.first.score, 0.91);
    });

    test('ProcessingStatus terminal helpers', () {
      expect(ProcessingStatus.completed.canAsk, isTrue);
      expect(ProcessingStatus.processing.canAsk, isFalse);
      expect(ProcessingStatus.failed.isTerminal, isTrue);
    });
  });
}
