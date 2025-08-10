import 'package:dio/dio.dart';
import 'package:wandroid/network/result/result.dart';

extension DioResultExtension on Dio {
  Future<Result<T>> _requestResult<T>(
    String path, {
    required String method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );

      final json = response.data;

      // 业务错误码处理
      if (json is Map && json.containsKey('code')) {
        if (json['code'] != 0) {
          return Result.failure(json['msg'] ?? 'Unknown error');
        }
        return Result.success(parser(json['data']));
      }

      // 没有 code 字段就直接解析
      return Result.success(parser(json));
    } catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<T>> getResult<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
  }) => _requestResult(
    path,
    method: 'GET',
    queryParameters: queryParameters,
    parser: parser,
  );

  Future<Result<T>> postResult<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required T Function(dynamic json) parser,
  }) => _requestResult(
    path,
    method: 'POST',
    queryParameters: queryParameters,
    data: data,
    parser: parser,
  );

  Future<Result<T>> putResult<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required T Function(dynamic json) parser,
  }) => _requestResult(
    path,
    method: 'PUT',
    queryParameters: queryParameters,
    data: data,
    parser: parser,
  );

  Future<Result<T>> deleteResult<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required T Function(dynamic json) parser,
  }) => _requestResult(
    path,
    method: 'DELETE',
    queryParameters: queryParameters,
    data: data,
    parser: parser,
  );
}
