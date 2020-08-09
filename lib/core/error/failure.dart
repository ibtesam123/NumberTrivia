abstract class Failure {
  String message;
  Failure(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Failure && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class EmptyFailure extends Failure {
  EmptyFailure(String message) : super(message);
}

class NoInternetFailure extends Failure {
  NoInternetFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class DataNotFoundFailure extends Failure {
  DataNotFoundFailure(String message) : super(message);
}
