class InvoiceModel {
  final int? id;
  final String invoiceNumber;
  final int clientID;
  final String invoiceDate;
  final String dueDate;
  final double subtotal;
  final double cgst;
  final double sgst;
  final double igst;
  final double total;
  final double paidAmount;
  final String status;
  final String? notes;
  final bool isInterstate;
  final String? createdAt;

  InvoiceModel({
    this.id,
    required this.invoiceNumber,
    required this.clientID,
    required this.invoiceDate,
    required this.dueDate,
    required this.subtotal,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.total,
    this.paidAmount = 0.0,
    this.status = 'UNPAID',
    this.notes,
    this.isInterstate = false,
    this.createdAt,
  });

  double get balanceAmount => total - paidAmount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'client_id': clientID,
      'invoice_date': invoiceDate,
      'due_date': dueDate,
      'subtotal': subtotal,
      'cgst': cgst,
      'sgst': sgst,
      'igst': igst,
      'total': total,
      'paid_amount': paidAmount,
      'status': status,
      'notes': notes,
      'is_interstate': isInterstate ? 1 : 0,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['id'],
      invoiceNumber: map['invoice_number'] ?? '',
      clientID: map['client_id'],
      invoiceDate: map['invoice_date'] ?? '',
      dueDate: map['due_date'] ?? '',
      subtotal: (map['subtotal'] as num).toDouble(),
      cgst: (map['cgst'] as num).toDouble(),
      sgst: (map['sgst'] as num).toDouble(),
      igst: (map['igst'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      paidAmount: (map['paid_amount'] as num).toDouble(),
      status: map['status'] ?? 'UNPAID',
      notes: map['notes'],
      isInterstate: (map['is_interstate'] == 1),
      createdAt: map['created_at'],
    );
  }
}
