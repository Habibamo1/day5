import 'package:day5/data/api/api_client.dart';
import 'package:day5/data/models/product_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ProductServises {
  ApiClient _apiClient = ApiClient();

  Future<List<Product>> getProduct() async {
    try {
      Response res = await _apiClient.getData('/products');
      if (res.statusCode == 200 && res.data != null) {
        ProudctModel proudctModel = ProudctModel.fromJson(res.data);
        return proudctModel.products;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }
}
