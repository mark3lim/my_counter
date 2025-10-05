class DataNumberLimitError implements Exception {
  final String message;

  DataNumberLimitError(this.message);

  @override
  String toString() => 'DataNumberLimitError: $message';
}