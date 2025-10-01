import 'package:day5/data/models/product_models.dart';
import 'package:day5/data/services/product_services.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _list = [];
  bool _isLoding = true;
  ProductServises _productServises = ProductServises();
  List<Product> get list => _list;
  bool get isLoding => _isLoding;

  ProductProvider() {
    getProduct();
  }

  Future getProduct() async {
    _list = await _productServises.getProduct();
    _isLoding = false;
    notifyListeners();
  }
}
