class AppException implements Exception {
  final String message;
  AppException([this.message = "حدث خطأ غير متوقع."]);

  @override
  String toString() => message;
}
