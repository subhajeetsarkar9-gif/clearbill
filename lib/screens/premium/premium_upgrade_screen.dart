import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/premium_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/payment_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_formatter.dart';

class PremiumUpgradeScreen extends StatefulWidget {
  const PremiumUpgradeScreen({super.key});

  @override
  State<PremiumUpgradeScreen> createState() => _PremiumUpgradeScreenState();
}

class _PremiumUpgradeScreenState extends State<PremiumUpgradeScreen> {
  String _selectedPlan = 'monthly';
  bool _isLoading = false;

  final List<String> _features = [
    'Unlimited Invoices per month',
    'Unlimited Clients & Products',
    'Edit Invoice Numbers Customly',
    'Direct WhatsApp Share for Invoices',
    'Google Drive Automatic Data Backup',
    'Revenue Analytics & GST Charts',
    'GSTR-1 Tax Export Ready',
  ];

  @override
  Widget build(BuildContext context) {
    final premium = Provider.of<PremiumProvider>(context);
    final business = Provider.of<BusinessProvider>(context).business;
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Clear Bill Pro'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (premium.isPremium) ...[
              Card(
                color: const Color(0xFFE6F4EA),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.stars, color: AppColors.primary, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            premium.planName,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Valid till ${DateFormatter.format(premium.expiryDate ?? DateTime.now())} (${premium.daysLeftText})',
                        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      ..._features.map((f) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                                const SizedBox(width: 8),
                                Text(f, style: const TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Everything Unlimited',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ..._features.map((f) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                                const SizedBox(width: 10),
                                Expanded(child: Text(f, style: const TextStyle(fontSize: 14))),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Select Subscription Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPlan = 'monthly'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _selectedPlan == 'monthly' ? AppColors.primary.withOpacity(0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedPlan == 'monthly' ? AppColors.primary : Colors.grey.shade300,
                            width: _selectedPlan == 'monthly' ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: const [
                            Text('Monthly', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 8),
                            Text('₹99', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            Text('/month', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPlan = 'yearly'),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _selectedPlan == 'yearly' ? AppColors.primary.withOpacity(0.08) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedPlan == 'yearly' ? AppColors.primary : Colors.grey.shade300,
                                width: _selectedPlan == 'yearly' ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: const [
                                Text('Yearly', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                SizedBox(height: 8),
                                Text('₹899', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                Text('/year', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -10,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAC775),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Save ₹289',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() => _isLoading = true);
                          PaymentService.startPayment(
                            context: context,
                            planType: _selectedPlan,
                            userPhone: business?.phone ?? '',
                            userEmail: auth.userEmail,
                            onSuccess: (paymentId, planType) async {
                              await PaymentService.activateAfterPayment(paymentId, planType, premium);
                              if (mounted) {
                                setState(() => _isLoading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Welcome to Clear Bill Pro! Plan activated successfully.')),
                                );
                                Navigator.pop(context);
                              }
                            },
                            onFailure: (error) {
                              if (mounted) {
                                setState(() => _isLoading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Payment Failed: $error'), backgroundColor: Colors.red),
                                );
                              }
                            },
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _selectedPlan == 'monthly' ? 'Continue - ₹99/month' : 'Continue - ₹899/year',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
