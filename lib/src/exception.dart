class FluidException implements Exception {
  final String message;

  const FluidException(this.message);

  @override
  String toString() => "FluidException: $message";
}
