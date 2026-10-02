import 'package:flutter/material.dart';
import '../models/business_model.dart';
import '../database/business_dao.dart';

class BusinessProvider extends ChangeNotifier {
  final BusinessDAO _businessDAO = BusinessDAO();
  BusinessModel? _business;
  bool _isLoading = false;

  BusinessModel? get business => _business;
  bool get isLoading => _isLoading;
  bool get hasBusinessSetup => _business != null && _business!.name.isNotEmpty;

  Future<void> loadBusiness() async {
    _isLoading = true;
    notifyListeners();
    _business = await _businessDAO.getBusiness();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveBusiness(BusinessModel b) async {
    _isLoading = true;
    notifyListeners();
    await _businessDAO.insertOrUpdate(b);
    _business = b;
    _isLoading = false;
    notifyListeners();
    return true;
  }
}
