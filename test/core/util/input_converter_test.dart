import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architeture/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return integer when string represents an unsigned integer',
        () {
      final str = '123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Right(123));
    });

    test('should return a Failure when the string is not an integer', () {
      final str = 'abc';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a Failure when the string is not an integer', () {
      final str = 'abc';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a Failure when the string is a nagative integer', () {
      final str = '-123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
