import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Response> login(
    String path,
    Object? data,
    Map<String, dynamic> header,
  ) async {
    final resp = await _dio.post(
      path,
      data: data,
      options: Options(headers: header),
    );
    return resp;
  }

  Future<List<String>> getCategories() async {
    final resp = await _dio.get('/products/categories');
    return List<String>.from(resp.data);
  }

  Future<List<dynamic>> getAllProducts() async {
    final resp = await _dio.get('/products');
    return List<dynamic>.from(resp.data['products']);
  }

  Future<List<dynamic>> getProductsByCategory(String category) async {
    final resp = await _dio.get('/products/category/$category');
    return List<dynamic>.from(resp.data['products']);
  }
}
