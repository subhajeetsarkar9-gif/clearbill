class PaymentModel {
  final int? id;
  final int invoiceID;
  final double amountPaid;
  final String paymentDate;
  final String paymentMethod;
  final String? note;
  final String? createdAt;

  PaymentModel({
    this.id,
    required this.invoiceID,
    required this.amountPaid,
    required this.paymentDate,
    required this.paymentMethod,
    this.note,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice_id': invoiceID,
      'amount_paid': amountPaid,
      'payment_date': paymentDate,
      'payment_method': paymentMethod,
      'note': note,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'],
      invoiceID: map['invoice_id'],
      amountPaid: (map['amount_paid'] as num).toDouble(),
      paymentDate: map['payment_date'] ?? '',
      paymentMethod: map['payment_method'] ?? 'Cash',
      note: map['note'],
      createdAt: map['created_at'],
    );
  }
}
