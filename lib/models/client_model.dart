class ClientModel {
  final int? id;
  final String name;
  final String? phone;
  final String? email;
  final String? gstin;
  final String? billingAddress;
  final String? city;
  final String? state;
  final String? stateCode;
  final String? createdAt;

  ClientModel({
    this.id,
    required this.name,
    this.phone,
    this.email,
    this.gstin,
    this.billingAddress,
    this.city,
    this.state,
    this.stateCode,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'gstin': gstin,
      'billing_address': billingAddress,
      'city': city,
      'state': state,
      'state_code': stateCode,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'],
      name: map['name'] ?? '',
      phone: map['phone'],
      email: map['email'],
      gstin: map['gstin'],
      billingAddress: map['billing_address'],
      city: map['city'],
      state: map['state'],
      stateCode: map['state_code'],
      createdAt: map['created_at'],
    );
  }
}
