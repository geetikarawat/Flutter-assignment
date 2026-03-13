import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({required Dio dio}) : _dio = dio {
    _dio.options = BaseOptions(
      baseUrl: 'https://newsapi.org/v2',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    );
  }

  final Dio _dio;

  static const String _apiKey = '3da9a01da4024271bd51ccae4407b91e';

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    final qp = Map<String, dynamic>.from(queryParameters ?? {});
    qp['apiKey'] = _apiKey;
    return _dio.get(path, queryParameters: qp);
  }
}

