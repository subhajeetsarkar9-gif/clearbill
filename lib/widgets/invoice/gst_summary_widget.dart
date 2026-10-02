import 'package:flutter/material.dart';
import '../../utils/currency_formatter.dart';

class GSTSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double cgst;
  final double sgst;
  final double igst;
  final double total;
  final bool isInterstate;

  const GSTSummaryWidget({
    super.key,
    required this.subtotal,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.total,
    required this.isInterstate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _row('Subtotal', CurrencyFormatter.format(subtotal)),
          if (!isInterstate) ...[
            _row('CGST', CurrencyFormatter.format(cgst)),
            _row('SGST', CurrencyFormatter.format(sgst)),
          ] else ...[
            _row('IGST', CurrencyFormatter.format(igst)),
          ],
          const Divider(),
          _row('Grand Total', CurrencyFormatter.format(total), isBold: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: isBold ? 16 : 14)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: isBold ? 16 : 14)),
        ],
      ),
    );
  }
}
