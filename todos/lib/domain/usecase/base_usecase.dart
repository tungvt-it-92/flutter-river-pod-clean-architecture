import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:todos/core/error/exceptions.dart';
import 'package:todos/core/error/failures.dart';

abstract class BaseUseCase<T, R> {
  Future<Either<Failure, T>> execute(R? arg) async {
    try {
      final res = await main(arg);
      return Right(res);
    } on RemoteException catch (ex) {
      return Left(
        RemoteFailure(
          msg: ex.errorMessage,
          code: ex.httpStatusCode,
          errorCode: ex.errorCode,
        ),
      );
    } on CacheException catch (ex) {
      return Left(LocalFailure(msg: ex.errorMessage));
    } on PlatformException catch (ex) {
      return Left(LocalFailure(msg: ex.message));
    } on IOException catch (ex) {
      return Left(LocalFailure(msg: ex.errorMessage, errorCode: ex.errorCode));
    } on Exception catch (ex) {
      return Left(UnknownFailure(msg: ex.toString()));
    } on Error catch (ex) {
      return Left(UnknownFailure(msg: ex.toString()));
    }
  }

  Future<T> main(R? arg);
}
