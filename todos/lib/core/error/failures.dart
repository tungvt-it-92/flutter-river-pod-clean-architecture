import 'package:equatable/equatable.dart';

abstract class Failure {
  final String? message;
  final  int? httpStatusCode;
  final  String? errorCode;

  Failure({this.message, this.httpStatusCode, this.errorCode});
}

class RemoteFailure extends Failure with EquatableMixin {
  final dynamic data;

  RemoteFailure({String? msg, this.data, int? code, super.errorCode}) : super(message: msg, httpStatusCode: code);

  @override
  List<Object?> get props => [message, httpStatusCode, errorCode];
}

class LocalFailure extends Failure with EquatableMixin {
  LocalFailure({String? msg, super.errorCode}) : super(message: msg);

  @override
  List<Object?> get props => [message, errorCode];
}

class PlatformFailure extends Failure {
  PlatformFailure({String? msg, super.errorCode}) : super(message: msg);
}

class UnknownFailure extends Failure with EquatableMixin {
  UnknownFailure({String? msg, int? code, super.errorCode}) : super(message: msg, httpStatusCode: code);

  @override
  List<Object?> get props => [message, errorCode];
}

const internetErrorMessage = 'internetErrorMessage';
const socketErrorMessage = 'socketErrorMessage';
const serverErrorMessage = 'server_error_message';
const unknownErrorMessage = 'serverErrorMessage';

const httpStatusServerMaintain = 520;
const httpStatusServerBadGateway = 502;
const accessTokenExpiredCode = 401;
