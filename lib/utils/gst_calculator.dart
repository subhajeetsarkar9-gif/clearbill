import '../models/invoice_item_model.dart';

class GSTCalculator {
  static Map<String, double> calculateItemGST({
    required double quantity,
    required double rate,
    required double gstPercent,
  }) {
    final double baseAmount = quantity * rate;
    final double gstAmount = baseAmount * (gstPercent / 100.0);
    final double totalAmount = baseAmount + gstAmount;

    return {
      'baseAmount': baseAmount,
      'gstAmount': gstAmount,
      'totalAmount': totalAmount,
    };
  }

  static Map<String, double> calculateInvoiceTotals({
    required List<InvoiceItemModel> items,
    required bool isInterState,
  }) {
    double subtotal = 0.0;
    double totalGST = 0.0;

    for (final item in items) {
      subtotal += (item.quantity * item.rate);
      totalGST += item.gstAmount;
    }

    final double cgst = isInterState ? 0.0 : (totalGST / 2.0);
    final double sgst = isInterState ? 0.0 : (totalGST / 2.0);
    final double igst = isInterState ? totalGST : 0.0;
    final double grandTotal = subtotal + totalGST;

    return {
      'subtotal': subtotal,
      'totalGST': totalGST,
      'cgst': cgst,
      'sgst': sgst,
      'igst': igst,
      'grandTotal': grandTotal,
    };
  }
}
