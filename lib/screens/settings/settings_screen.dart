import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/premium_provider.dart';
import '../../providers/client_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/invoice_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants.dart';
import '../../utils/date_formatter.dart';
import '../../services/google_drive_backup_service.dart';
import '../../widgets/common/limit_reached_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final premium = Provider.of<PremiumProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: premium.isPremium
                  ? (premium.isYearly ? const Color(0xFFFFF8E1) : const Color(0xFFE6F4EA))
                  : Colors.grey.shade100,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          premium.planName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: premium.isPremium ? Colors.black87 : Colors.grey.shade800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: premium.isPremium ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            premium.isPremium ? 'Active' : 'Free',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (premium.isPremium) ...[
                      Text(
                        'Valid till ${DateFormatter.format(premium.expiryDate ?? DateTime.now())} (${premium.daysLeftText})',
                        style: const TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ] else ...[
                      const Text(
                        '10 invoices/month • 5 clients • Limited features',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.premiumUpgrade),
                              child: const Text('₹99/month'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.premiumUpgrade),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1D9E75),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('₹899/year (Best)'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined, color: Colors.blue),
            title: const Text('Backup to Google Drive'),
            subtitle: const Text('Save all your invoices and business data safely'),
            onTap: () async {
              if (!premium.canBackupCloud) {
                LimitReachedDialog.showBackupLocked(context);
                return;
              }

              final bProvider = Provider.of<BusinessProvider>(context, listen: false);
              final cProvider = Provider.of<ClientProvider>(context, listen: false);
              final pProvider = Provider.of<ProductProvider>(context, listen: false);
              final iProvider = Provider.of<InvoiceProvider>(context, listen: false);

              final backupData = {
                'business': bProvider.business?.toMap(),
                'clients': cProvider.clients.map((c) => c.toMap()).toList(),
                'products': pProvider.products.map((p) => p.toMap()).toList(),
                'invoices': iProvider.invoices.map((i) => i.toMap()).toList(),
                'timestamp': DateTime.now().toIso8601String(),
              };

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backing up data to Google Drive...')),
              );

              final success = await GoogleDriveBackupService.backupToGoogleDrive(backupData);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Backup saved to Google Drive!' : 'Backup failed. Please try again.'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_download_outlined, color: Colors.orange),
            title: const Text('Restore from Google Drive'),
            subtitle: const Text('Restore previously backed up data'),
            onTap: () async {
              if (!premium.canBackupCloud) {
                LimitReachedDialog.showBackupLocked(context);
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Checking Google Drive backup...')),
              );

              final data = await GoogleDriveBackupService.restoreFromGoogleDrive();
              if (context.mounted) {
                if (data != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Backup restored successfully!'), backgroundColor: Colors.green),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No backup file found in Google Drive.'), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),

          const Divider(),

          SwitchListTile(
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode),
            value: themeProvider.isDarkMode,
            onChanged: (val) => themeProvider.toggleTheme(val),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Business Details'),
            onTap: () => Navigator.pushNamed(context, AppRoutes.businessSetup),
          ),
          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text('Rate Clear Bill'),
            subtitle: const Text('Play Store'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            subtitle: Text('${AppConstants.appName} - ${AppConstants.appDescription} v${AppConstants.appVersion}'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
