class BusinessModel {
  final int? id;
  final String name;
  final String? gstin;
  final String? address;
  final String? phone;
  final String? email;
  final String? logoPath;
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;
  final String? upiId;
  final String? terms;
  final String invoicePrefix;
  final int invoiceStartNumber;
  final String? stateCode;
  final String? createdAt;

  BusinessModel({
    this.id,
    required this.name,
    this.gstin,
    this.address,
    this.phone,
    this.email,
    this.logoPath,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.upiId,
    this.terms,
    this.invoicePrefix = 'INV',
    this.invoiceStartNumber = 1,
    this.stateCode,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gstin': gstin,
      'address': address,
      'phone': phone,
      'email': email,
      'logo_path': logoPath,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'upi_id': upiId,
      'terms': terms,
      'invoice_prefix': invoicePrefix,
      'invoice_start_number': invoiceStartNumber,
      'state_code': stateCode,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      id: map['id'],
      name: map['name'] ?? '',
      gstin: map['gstin'],
      address: map['address'],
      phone: map['phone'],
      email: map['email'],
      logoPath: map['logo_path'],
      bankName: map['bank_name'],
      accountNumber: map['account_number'],
      ifscCode: map['ifsc_code'],
      upiId: map['upi_id'],
      terms: map['terms'],
      invoicePrefix: map['invoice_prefix'] ?? 'INV',
      invoiceStartNumber: map['invoice_start_number'] ?? 1,
      stateCode: map['state_code'],
      createdAt: map['created_at'],
    );
  }
}
