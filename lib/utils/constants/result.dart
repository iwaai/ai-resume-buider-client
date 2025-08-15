enum ResultStatus { idle, successful, error }

class Result<T extends Object> {
  final T? event;
  final ResultStatus status;
  final String message;

  Result(this.status, this.message, this.event);

  factory Result.successful(String message, T event) =>
      Result(ResultStatus.successful, message, event);

  factory Result.error(String message, T event) =>
      Result(ResultStatus.error, message, event);

  factory Result.idle() => Result(ResultStatus.idle, "Not Processing", null);
}
