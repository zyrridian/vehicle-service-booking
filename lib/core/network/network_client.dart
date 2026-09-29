import 'package:dio/dio.dart';
import 'package:flutter_network_debugger/flutter_network_debugger.dart';
import 'api_endpoints.dart';
import '../../data/datasources/local/auth_local_datasource.dart';

abstract class NetworkClient {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String path, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<dynamic> put(String path, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<dynamic> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters});
}

class NetworkClientImpl implements NetworkClient {
  late final Dio _dio;
  final AuthLocalDataSource _authLocalDataSource;

  NetworkClientImpl(this._authLocalDataSource) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _authLocalDataSource.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
    _dio.interceptors.add(FlutterNetworkDebuggerDioInterceptor());
  }

  dynamic _processResponse(Response response) {
    if (response.data is Map<String, dynamic>) {
      final data = response.data;
      if (data['status'] == 'success') {
        return data['data'];
      } else {
        throw Exception(data['message'] ?? 'An error occurred');
      }
    }
    return response.data;
  }

  void _handleError(DioException e) {
    if (e.response != null && e.response!.data is Map<String, dynamic>) {
      throw Exception(e.response!.data['message'] ?? 'An error occurred');
    }
    throw Exception(e.message);
  }

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _processResponse(response);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<dynamic> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters);
      return _processResponse(response);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<dynamic> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.put(path, data: data, queryParameters: queryParameters);
      return _processResponse(response);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<dynamic> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(path, data: data, queryParameters: queryParameters);
      return _processResponse(response);
    } on DioException catch (e) {
      _handleError(e);
    }
  }
}
