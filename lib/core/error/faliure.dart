import 'package:equatable/equatable.dart';

abstract class Faliure extends Equatable {
  final String message;
  const Faliure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFaliure extends Faliure {
  const ServerFaliure(super.message);
}

class NoQueryFaliure extends Faliure {
  const NoQueryFaliure(super.message);
}

class ConnectionFaliure extends Faliure {
  const ConnectionFaliure(super.message);
}

class AWSUploadFaliure extends Faliure {
  const AWSUploadFaliure(super.message);
}
