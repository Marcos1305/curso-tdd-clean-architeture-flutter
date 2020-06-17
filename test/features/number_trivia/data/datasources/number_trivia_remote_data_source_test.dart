import 'dart:convert';

import 'package:flutter_tdd_clean_architeture/core/error/exceptions.dart';
import 'package:flutter_tdd_clean_architeture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architeture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (realInvocation) async => http.Response(
        fixture('trivia.json'),
        200,
      ),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (realInvocation) async => http.Response(
        'Something went wrong',
        404,
      ),
    );
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(
        fixture('trivia.json'),
      ),
    );

    test('''
      should perform a GET request on a URL with number being
      the endpoint and with application/json header''', () {
      setUpMockHttpClientSuccess200();

      dataSource.getConcreteNumberTrivia(tNumber);

      verify(
        mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {
            'Content-Type': 'application-json',
          },
        ),
      );
    });

    test('should return a NumberTrivia when the response code is 200',
        () async {
      setUpMockHttpClientSuccess200();

      final response = await dataSource.getConcreteNumberTrivia(tNumber);

      expect(response, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () {
      setUpMockHttpClientFailure404();

      final call = dataSource.getConcreteNumberTrivia;

      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(
        fixture('trivia.json'),
      ),
    );

    test('''
      should perform a GET request on a URL with number being
      the endpoint and with application/json header''', () {
      setUpMockHttpClientSuccess200();

      dataSource.getRandomNumberTrivia();

      verify(
        mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {
            'Content-Type': 'application-json',
          },
        ),
      );
    });

    test('should return a NumberTrivia when the response code is 200',
        () async {
      setUpMockHttpClientSuccess200();

      final response = await dataSource.getRandomNumberTrivia();

      expect(response, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () {
      setUpMockHttpClientFailure404();

      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
