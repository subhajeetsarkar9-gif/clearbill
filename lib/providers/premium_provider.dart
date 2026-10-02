import 'package:flutter/material.dart';
import '../utils/plan_manager.dart';

class PremiumProvider extends ChangeNotifier {
  bool _isPremium = false;
  DateTime? _expiryDate;
  String _planType = 'free';
  String _planName = 'Clear Bill Free';

  bool get isPremium => _isPremium;
  DateTime? get expiryDate => _expiryDate;
  String get planType => _planType;
  String get planName => _planName;
  bool get isYearly => _planType == 'yearly';

  bool get isExpired {
    if (_expiryDate == null) return false;
    return _expiryDate!.isBefore(DateTime.now());
  }

  String get daysLeftText {
    if (!_isPremium || _expiryDate == null) return 'Expired';
    final diff = _expiryDate!.difference(DateTime.now());
    if (diff.inDays > 30) {
      final months = (diff.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} left';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} left';
    } else {
      return 'Expires today';
    }
  }

  Future<void> loadPlanStatus() async {
    _isPremium = await PlanManager.isPremium();
    _expiryDate = await PlanManager.getExpiry();
    _planType = await PlanManager.getPlanType();
    _planName = await PlanManager.getPlanName();

    if (_isPremium && isExpired) {
      await deactivatePremium();
      return;
    }

    notifyListeners();
  }

  Future<void> activatePremium(DateTime expiry, String planType) async {
    await PlanManager.activatePremium(expiry, planType);
    _isPremium = true;
    _expiryDate = expiry;
    _planType = planType;
    _planName = await PlanManager.getPlanName();
    notifyListeners();
  }

  Future<void> deactivatePremium() async {
    await PlanManager.deactivatePremium();
    _isPremium = false;
    _expiryDate = null;
    _planType = 'free';
    _planName = 'Clear Bill Free';
    notifyListeners();
  }

  bool canCreateInvoice(int count) => _isPremium || count < PlanManager.freeInvoiceLimit;
  bool canAddClient(int count) => _isPremium || count < PlanManager.freeClientLimit;
  bool canAddProduct(int count) => _isPremium || count < PlanManager.freeProductLimit;

  bool get canShareWhatsApp => _isPremium;
  bool get canAccessReports => _isPremium;
  bool get canBackupCloud => _isPremium;
  bool get canEditInvoiceNumber => _isPremium;
}
