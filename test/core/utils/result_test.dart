import 'package:flutter_test/flutter_test.dart';
import 'package:lingualearn/core/error/failures.dart';
import 'package:lingualearn/core/utils/result.dart';

void main() {
  group('Result', () {
    test('success keeps data and no failure', () {
      final result = Result.success('ok');

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.data, 'ok');
      expect(result.failure, isNull);
    });

    test('failure keeps failure and no data', () {
      const failure = ServerFailure('bad');
      final result = Result<String>.failure(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.data, isNull);
      expect(result.failure, failure);
    });
  });
}
