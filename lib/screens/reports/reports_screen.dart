import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/invoice_provider.dart';
import '../../utils/constants.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/charts/gst_chart.dart';
import '../../widgets/charts/revenue_chart.dart';
import '../../widgets/common/limit_reached_dialog.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invProvider = Provider.of<InvoiceProvider>(context);
    double cgst = 0, sgst = 0, igst = 0;
    for (var i in invProvider.invoices) {
      cgst += i.cgst;
      sgst += i.sgst;
      igst += i.igst;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports - ${AppConstants.appName}'),
      ),
      body: PremiumFeatureWidget(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Monthly Revenue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const RevenueChart(),
            const SizedBox(height: 20),
            const Text('GST Collected Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            GSTChart(cgst: cgst, sgst: sgst, igst: igst),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total CGST:'),
                        Text(CurrencyFormatter.format(cgst), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total SGST:'),
                        Text(CurrencyFormatter.format(sgst), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total IGST:'),
                        Text(CurrencyFormatter.format(igst), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
