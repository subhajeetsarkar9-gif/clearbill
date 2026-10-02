import 'package:flutter/material.dart';
import '../../models/invoice_model.dart';
import '../../utils/currency_formatter.dart';
import '../../theme/app_colors.dart';

class RecentInvoiceTile extends StatelessWidget {
  final InvoiceModel invoice;
  final VoidCallback onTap;

  const RecentInvoiceTile({
    super.key,
    required this.invoice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: const Icon(Icons.receipt, color: AppColors.primary),
      ),
      title: Text(invoice.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Status: ${invoice.status}'),
      trailing: Text(
        CurrencyFormatter.format(invoice.total),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
