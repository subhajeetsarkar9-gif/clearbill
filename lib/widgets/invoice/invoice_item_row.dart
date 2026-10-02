import 'package:flutter/material.dart';
import '../../models/invoice_item_model.dart';
import '../../utils/currency_formatter.dart';

class InvoiceItemRow extends StatelessWidget {
  final InvoiceItemModel item;
  final VoidCallback? onDelete;

  const InvoiceItemRow({
    super.key,
    required this.item,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${item.quantity} x ₹${item.rate} (${item.gstPercent}% GST)',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(item.totalAmount),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
