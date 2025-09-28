import 'package:dio/dio.dart';
import '../../constants/api_constants.dart';

class ApiClient {
  final Dio dio;

  ApiClient({ Dio? dioOverride }) : dio = dioOverride ?? Dio() {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<Response> get(String path, { Map<String, dynamic>? queryParameters }) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, Map<String, dynamic> body) {
    return dio.post(path, data: body);
  }

  Future<Response> put(String path, Map<String, dynamic> body) {
    return dio.put(path, data: body);
  }

  Future<Response> patch(String path, Map<String, dynamic> body) {
    return dio.patch(path, data: body);
  }

  Future<Response> delete(String path) {
    return dio.delete(path);
  }
}
