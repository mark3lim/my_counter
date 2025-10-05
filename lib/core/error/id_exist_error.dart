class IdExistError implements Exception {
  final String message;

  IdExistError(this.message);

  @override
  String toString() => 'IdExistError: $message';
}