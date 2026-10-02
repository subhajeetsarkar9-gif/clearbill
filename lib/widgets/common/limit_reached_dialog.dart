import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/premium_provider.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';

class LimitReachedDialog extends StatelessWidget {
  final String title;
  final String message;

  const LimitReachedDialog({
    super.key,
    required this.title,
    required this.message,
  });

  static void show(BuildContext context, {required String title, required String message}) {
    showDialog(
      context: context,
      builder: (ctx) => LimitReachedDialog(title: title, message: message),
    );
  }

  static void showInvoiceLimit(BuildContext context) {
    show(
      context,
      title: 'Invoice Limit Reached',
      message:
          'You have used all 10 free invoices this month. Upgrade to Clear Bill Pro for unlimited invoices.',
    );
  }

  static void showClientLimit(BuildContext context) {
    show(
      context,
      title: 'Client Limit Reached',
      message:
          'You can add up to 5 clients on the free plan. Upgrade to Clear Bill Pro to add unlimited clients.',
    );
  }

  static void showProductLimit(BuildContext context) {
    show(
      context,
      title: 'Product Limit Reached',
      message:
          'You can add up to 10 products on the free plan. Upgrade to Clear Bill Pro to add unlimited products.',
    );
  }

  static void showWhatsAppLocked(BuildContext context) {
    show(
      context,
      title: 'Premium Feature',
      message: 'Share invoices directly on WhatsApp with Clear Bill Pro.',
    );
  }

  static void showReportsLocked(BuildContext context) {
    show(
      context,
      title: 'Reports Locked',
      message:
          'Upgrade to Clear Bill Pro to access revenue reports and GST breakdown charts.',
    );
  }

  static void showBackupLocked(BuildContext context) {
    show(
      context,
      title: 'Backup Locked',
      message: 'Upgrade to Clear Bill Pro to backup your data to Google Drive.',
    );
  }

  static void showEditInvoiceLocked(BuildContext context) {
    show(
      context,
      title: 'Edit Invoice Number',
      message:
          'Customize your invoice numbers with Clear Bill Pro. Upgrade now to edit invoice numbers your way.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3D6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock, size: 36, color: Color(0xFFD97706)),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Maybe Later', style: TextStyle(color: Colors.grey)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.premiumUpgrade);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Upgrade Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumFeatureWidget extends StatelessWidget {
  final Widget child;
  final String lockTitle;
  final String lockSubtitle;

  const PremiumFeatureWidget({
    super.key,
    required this.child,
    this.lockTitle = 'Unlock Reports & GST Insights',
    this.lockSubtitle = 'Upgrade to Clear Bill Pro to access full analytics.',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumProvider>(
      builder: (context, premium, _) {
        if (premium.isPremium) return child;

        return Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: IgnorePointer(child: child),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.15),
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundColor: Color(0xFFFFF3D6),
                            child: Icon(Icons.lock, size: 28, color: Color(0xFFD97706)),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            lockTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lockSubtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.premiumUpgrade),
                            icon: const Icon(Icons.star, size: 18),
                            label: const Text('Upgrade to Pro'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
