import 'package:day5/constant/api_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  ApiClient() {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
        filter: (options, args) {
          // don't print requests with uris containing '/posts'
          if (options.path.contains('/posts')) {
            return false;
          }
          // don't print responses with unit8 list data
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    );
  }

  Future<Response> getData(String path, {Map<String, dynamic>? query}) async {
    return await dio.get(path, queryParameters: query);
  }

  /// POST request
  Future<Response> postData(String path, {Map<String, dynamic>? body}) async {
    return await dio.post(path, data: body);
  }
}
