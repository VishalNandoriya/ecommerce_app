import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    if (_products.isEmpty) {
      _products = await ApiService.fetchProducts();
      notifyListeners();
    }
  }
}
