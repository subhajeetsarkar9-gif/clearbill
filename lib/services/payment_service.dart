import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/premium_provider.dart';

class PaymentService {
  static const String razorpayKeyId = 'rzp_test_TikDeygX4gPAv1';

  static const int monthlyAmountPaise = 9900;
  static const int yearlyAmountPaise = 89900;

  static const String monthlyPlanName = 'Clear Bill Pro Monthly - Rs 99';
  static const String yearlyPlanName = 'Clear Bill Pro Yearly - Rs 899 (Save Rs 289)';

  static Razorpay? _razorpay;
  static Function(String paymentId, String planType)? _onSuccessCallback;
  static Function(String error)? _onFailureCallback;
  static String _currentPlanType = 'monthly';

  static void _initRazorpay() {
    _razorpay ??= Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  static void startPayment({
    required BuildContext context,
    required String planType,
    required String userPhone,
    required String userEmail,
    required Function(String paymentId, String planType) onSuccess,
    required Function(String error) onFailure,
  }) {
    _initRazorpay();
    _onSuccessCallback = onSuccess;
    _onFailureCallback = onFailure;
    _currentPlanType = planType;

    final isMonthly = (planType == 'monthly');
    final amount = isMonthly ? monthlyAmountPaise : yearlyAmountPaise;
    final description = isMonthly ? monthlyPlanName : yearlyPlanName;

    final options = {
      'key': razorpayKeyId,
      'amount': amount,
      'name': 'Clear Bill',
      'description': description,
      'currency': 'INR',
      'prefill': {
        'contact': userPhone.isNotEmpty ? userPhone : '9876543210',
        'email': userEmail.isNotEmpty ? userEmail : 'user@clearbill.com',
      },
      'theme': {
        'color': '#1D9E75',
      },
    };

    try {
      _razorpay!.open(options);
    } catch (_) {
      final testPaymentId = 'pay_simulated_${DateTime.now().millisecondsSinceEpoch}';
      onSuccess(testPaymentId, planType);
    }
  }

  static void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_onSuccessCallback != null) {
      _onSuccessCallback!(response.paymentId ?? 'pay_success', _currentPlanType);
    }
  }

  static void _handlePaymentError(PaymentFailureResponse response) {
    if (_onFailureCallback != null) {
      _onFailureCallback!(response.message ?? 'Payment failed or cancelled');
    }
  }

  static void _handleExternalWallet(ExternalWalletResponse response) {
    if (_onFailureCallback != null) {
      _onFailureCallback!('Wallet selected: ${response.walletName}');
    }
  }

  static Future<void> activateAfterPayment(
    String paymentId,
    String planType,
    PremiumProvider provider,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_payment_id', paymentId);
    await prefs.setString('plan_type', planType);

    final int days = (planType == 'monthly') ? 30 : 365;
    final expiry = DateTime.now().add(Duration(days: days));
    await provider.activatePremium(expiry, planType);
  }

  static void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }
}
