import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos/core/error/exceptions.dart';
import 'package:todos/core/error/failures.dart' as todo;
import 'package:todos/domain/usecase/base_usecase.dart';

abstract class AnyService {
  Future<dynamic> run();
}

class MockAnyService extends Mock implements AnyService {}

class TestBaseUseCaseImpl extends BaseUseCase<dynamic, dynamic> {
  AnyService service;

  TestBaseUseCaseImpl(this.service);

  @override
  Future main(dynamic arg) {
    return service.run();
  }
}

main() async {
  late BaseUseCase baseUseCase;
  late AnyService mockService;

  setUp(() {
    mockService = MockAnyService();
    baseUseCase = TestBaseUseCaseImpl(mockService);
  });

  tearDown(() {
    reset(mockService);
  });

  test('Should return value', () async {
    const value = Right(1);
    when(() => mockService.run()).thenAnswer((_) => Future.value(value));

    final result = await baseUseCase.execute(1);

    expect(result.getOrElse(() => null), value);
    expect(result.isRight(), true);
    verify(() => mockService.run()).called(1);
    verifyNoMoreInteractions(mockService);
  });

  List<Tuple2<dynamic, todo.Failure>> testCases = [
    Tuple2(
      RemoteException(
        errorCode: 'RemoteException',
        errorMessage: 'errorMessage',
        httpStatusCode: 1000,
      ),
      todo.RemoteFailure(
        errorCode: 'RemoteException',
        msg: 'errorMessage',
        code: 1000,
      ),
    ),
    Tuple2(
      CacheException(
        errorMessage: 'CacheException',
      ),
      todo.LocalFailure(
        msg: 'CacheException',
      ),
    ),
    Tuple2(
      PlatformException(
        message: 'PlatformException',
        code: '11',
      ),
      todo.LocalFailure(
        msg: 'PlatformException',
      ),
    ),
    Tuple2(
      IOException(
        errorMessage: 'IOException',
        errorCode: '11',
      ),
      todo.LocalFailure(
        msg: 'IOException',
        errorCode: '11',
      ),
    ),
    Tuple2(
      Exception(
        'ExceptionMsg',
      ),
      todo.UnknownFailure(
        msg: 'Exception: ExceptionMsg',
      ),
    ),
    Tuple2(
      Error(),
      todo.UnknownFailure(
        msg: Error().toString(),
      ),
    ),
  ];

  testCases.asMap().forEach((index, testCase) {
    test('Should return failure case $index', () async {
      when(() => mockService.run()).thenThrow(testCase.head);

      final result = await baseUseCase.execute(1);

      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, testCase.tail);
      }, (value) {
        expect(value, null);
      });
      verify(() => mockService.run()).called(1);
      verifyNoMoreInteractions(mockService);
    });
  });
}
