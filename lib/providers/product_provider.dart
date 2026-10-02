import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../database/product_dao.dart';

class ProductProvider extends ChangeNotifier {
  final ProductDAO _productDAO = ProductDAO();
  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    _products = await _productDAO.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addProduct(ProductModel product) async {
    await _productDAO.insert(product);
    await loadProducts();
    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {
    await _productDAO.update(product);
    await loadProducts();
    return true;
  }

  Future<bool> deleteProduct(int id) async {
    await _productDAO.delete(id);
    await loadProducts();
    return true;
  }
}
