import 'package:shared_preferences/shared_preferences.dart';

class PlanManager {
  static const int freeInvoiceLimit = 10;
  static const int freeClientLimit = 5;
  static const int freeProductLimit = 10;
  static const int monthlyPrice = 99;
  static const int yearlyPrice = 899;

  static const String keyIsPremium = 'is_premium';
  static const String keyExpiry = 'premium_expiry';
  static const String keyPlanType = 'plan_type';
  static const String keyPaymentId = 'last_payment_id';

  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isPrem = prefs.getBool(keyIsPremium) ?? false;
    final String? expiryStr = prefs.getString(keyExpiry);
    if (!isPrem || expiryStr == null) return false;

    try {
      final expiry = DateTime.parse(expiryStr);
      return expiry.isAfter(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  static Future<String> getPlanType() async {
    final prem = await isPremium();
    if (!prem) return 'free';
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyPlanType) ?? 'monthly';
  }

  static Future<String> getPlanName() async {
    final type = await getPlanType();
    if (type == 'yearly') return 'Clear Bill Pro Yearly';
    if (type == 'monthly') return 'Clear Bill Pro Monthly';
    return 'Clear Bill Free';
  }

  static Future<DateTime?> getExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(keyExpiry);
    if (str == null) return null;
    try {
      return DateTime.parse(str);
    } catch (_) {
      return null;
    }
  }

  static Future<void> activatePremium(DateTime expiry, String planType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsPremium, true);
    await prefs.setString(keyExpiry, expiry.toIso8601String());
    await prefs.setString(keyPlanType, planType);
  }

  static Future<void> deactivatePremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyIsPremium);
    await prefs.remove(keyExpiry);
    await prefs.remove(keyPlanType);
  }

  static Future<bool> canCreateInvoice(int count) async {
    return (await isPremium()) || count < freeInvoiceLimit;
  }

  static Future<bool> canAddClient(int count) async {
    return (await isPremium()) || count < freeClientLimit;
  }

  static Future<bool> canAddProduct(int count) async {
    return (await isPremium()) || count < freeProductLimit;
  }

  static Future<bool> canShareWhatsApp() async => await isPremium();
  static Future<bool> canAccessReports() async => await isPremium();
  static Future<bool> canBackupCloud() async => await isPremium();
  static Future<bool> canEditInvoiceNumber() async => await isPremium();

  static Future<int> getDaysLeft() async {
    final expiry = await getExpiry();
    if (expiry == null) return 0;
    final diff = expiry.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }
}
