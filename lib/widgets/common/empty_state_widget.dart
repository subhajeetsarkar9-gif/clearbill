import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  factory EmptyStateWidget.noInvoices({
    VoidCallback? onButtonPressed,
  }) {
    return EmptyStateWidget(
      icon: Icons.receipt_long,
      title: 'No invoices yet',
      subtitle: 'Create your first invoice in seconds.',
      buttonText: 'Create Invoice',
      onButtonPressed: onButtonPressed,
    );
  }

  factory EmptyStateWidget.noClients({
    VoidCallback? onButtonPressed,
  }) {
    return EmptyStateWidget(
      icon: Icons.people_outline,
      title: 'No clients added',
      subtitle: 'Add clients to auto-fill billing details.',
      buttonText: 'Add Client',
      onButtonPressed: onButtonPressed,
    );
  }

  factory EmptyStateWidget.noProducts({
    VoidCallback? onButtonPressed,
  }) {
    return EmptyStateWidget(
      icon: Icons.inventory_2_outlined,
      title: 'No products added',
      subtitle: 'Add items or services with default rates.',
      buttonText: 'Add Product',
      onButtonPressed: onButtonPressed,
    );
  }

  factory EmptyStateWidget.noReports() {
    return const EmptyStateWidget(
      icon: Icons.bar_chart_outlined,
      title: 'No reports data',
      subtitle: 'Create invoices to see revenue and GST insights.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: AppColors.primary),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onButtonPressed,
                icon: const Icon(Icons.add),
                label: Text(buttonText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
