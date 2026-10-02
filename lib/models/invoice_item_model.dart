class InvoiceItemModel {
  final int? id;
  final int? invoiceID;
  final String productName;
  final String? hsnCode;
  final double quantity;
  final double rate;
  final double gstPercent;
  final double gstAmount;
  final double totalAmount;

  InvoiceItemModel({
    this.id,
    this.invoiceID,
    required this.productName,
    this.hsnCode,
    required this.quantity,
    required this.rate,
    required this.gstPercent,
    required this.gstAmount,
    required this.totalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice_id': invoiceID,
      'product_name': productName,
      'hsn_code': hsnCode,
      'quantity': quantity,
      'rate': rate,
      'gst_percent': gstPercent,
      'gst_amount': gstAmount,
      'total_amount': totalAmount,
    };
  }

  factory InvoiceItemModel.fromMap(Map<String, dynamic> map) {
    return InvoiceItemModel(
      id: map['id'],
      invoiceID: map['invoice_id'],
      productName: map['product_name'] ?? '',
      hsnCode: map['hsn_code'],
      quantity: (map['quantity'] as num).toDouble(),
      rate: (map['rate'] as num).toDouble(),
      gstPercent: (map['gst_percent'] as num).toDouble(),
      gstAmount: (map['gst_amount'] as num).toDouble(),
      totalAmount: (map['total_amount'] as num).toDouble(),
    );
  }
}
