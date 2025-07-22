import 'package:dio/dio.dart';
class DioHelper {
  static final _dio = Dio(
      BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3/',
    headers: {
      'Authorization':"Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YjBiYTE3NWY1NWUxYzhhYzlhYTQxNzRiMjg4ODk4MCIsIm5iZiI6MTc1MDU3NDExNS4zNjA5OTk4LCJzdWIiOiI2ODU3YTQyMzczMWJhYzg0ZTAzOThjYWYiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.e47lbhr28k-Tn7E6hOFs2MhzX6nPvguSoaghIg3s6qs",
      'Accept': 'application/json',

    },
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  ));

  static Future<CustomResponse> post(String path,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return CustomResponse(
          isSuccess: true,
          data: response.data,
          statusCode: response.statusCode);
    } on DioException catch (ex) {
      return CustomResponse(
        isSuccess: false,
        data: ex.response?.data,
        msg: ex.error.toString(),
      );
    }}
    static Future<CustomResponse> get(String path,
      {Map<String, dynamic>? data}) async {
    try {

      final response = await _dio.get(path, queryParameters: data);
      return CustomResponse(
          isSuccess: true,
          data: response.data,
          statusCode: response.statusCode);
    } on DioException catch (ex) {
      return CustomResponse(
        isSuccess: false,
        data: ex.response?.data,
        msg: 'حدث خطأ أثناء تحميل البيانات. تأكد من الاتصال بالإنترنت.'
      );
    }
  }  static Future<CustomResponse> put(String path,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return CustomResponse(
          isSuccess: true,
          data: response.data,
          statusCode: response.statusCode);
    } on DioException catch (ex) {
      return CustomResponse(
        isSuccess: false,
        data: ex.response?.data,
          msg: 'حدث خطأ أثناء تحميل البيانات. تأكد من الاتصال بالإنترنت.'
      );
    }
  }  static Future<CustomResponse> delete(String path,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(path, data: data);
      return CustomResponse(
          isSuccess: true,
          data: response.data,
          statusCode: response.statusCode);
    } on DioException catch (ex) {
      return CustomResponse(
        isSuccess: false,
        data: ex.response?.data,
          msg: 'حدث خطأ أثناء تحميل البيانات. تأكد من الاتصال بالإنترنت.'
      );
    }
  }
}

class CustomResponse {
  final String msg;
  final bool isSuccess;
  final data;
  final int? statusCode;

  CustomResponse({
    this.statusCode,
    required this.isSuccess,
    this.data,
    this.msg = '',
  });
}
