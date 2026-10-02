import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearbill/providers/business_provider.dart';
import 'package:clearbill/providers/invoice_provider.dart';
import 'package:clearbill/providers/client_provider.dart';
import 'package:clearbill/providers/product_provider.dart';
import 'package:clearbill/routes/app_routes.dart';
import 'package:clearbill/utils/constants.dart';
import 'package:clearbill/utils/currency_formatter.dart';
import 'package:clearbill/theme/app_colors.dart';
import 'package:clearbill/widgets/dashboard/stats_card.dart';
import 'package:clearbill/widgets/dashboard/recent_invoice_tile.dart';
import 'package:clearbill/widgets/charts/revenue_chart.dart';
import 'package:clearbill/screens/invoice/invoice_list_screen.dart';
import 'package:clearbill/screens/client/client_list_screen.dart';
import 'package:clearbill/screens/reports/reports_screen.dart';
import 'package:clearbill/screens/settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InvoiceProvider>(context, listen: false).loadInvoices();
      Provider.of<ClientProvider>(context, listen: false).loadClients();
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _buildDashboardHome(),
      const InvoiceListScreen(),
      const ClientListScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Invoices'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.createInvoice),
              icon: const Icon(Icons.add),
              label: const Text('NEW INVOICE'),
            )
          : null,
    );
  }

  Widget _buildDashboardHome() {
    final business = Provider.of<BusinessProvider>(context).business;
    final invProvider = Provider.of<InvoiceProvider>(context);
    final clientProvider = Provider.of<ClientProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(AppConstants.appName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(AppConstants.appDescription, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Hello, ${business?.name ?? "Business"} 👋',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              StatsCard(
                title: 'Total Revenue',
                value: CurrencyFormatter.format(invProvider.totalRevenue),
                icon: Icons.account_balance_wallet,
                color: AppColors.success,
              ),
              StatsCard(
                title: 'Pending Amount',
                value: CurrencyFormatter.format(invProvider.totalPending),
                icon: Icons.pending_actions,
                color: AppColors.error,
              ),
            ],
          ),
          Row(
            children: [
              StatsCard(
                title: 'Invoices',
                value: '${invProvider.invoices.length}',
                icon: Icons.receipt,
                color: AppColors.primary,
              ),
              StatsCard(
                title: 'Clients',
                value: '${clientProvider.clients.length}',
                icon: Icons.people,
                color: AppColors.info,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Revenue Growth', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const RevenueChart(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Invoices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 1),
                child: const Text('View All'),
              ),
            ],
          ),
          if (invProvider.invoices.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text('No invoices created yet', style: TextStyle(color: Colors.grey))),
            )
          else
            ...invProvider.invoices.take(5).map(
                  (inv) => RecentInvoiceTile(
                    invoice: inv,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.invoiceDetail,
                      arguments: inv.id,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
