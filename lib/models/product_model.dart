class ProductModel {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final double gstPercent;
  final String unit;
  final String? hsnCode;
  final bool isService;
  final String? createdAt;

  ProductModel({
    this.id,
    required this.name,
    this.description,
    required this.price,
    required this.gstPercent,
    this.unit = 'pcs',
    this.hsnCode,
    this.isService = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'gst_percent': gstPercent,
      'unit': unit,
      'hsn_code': hsnCode,
      'is_service': isService ? 1 : 0,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      gstPercent: (map['gst_percent'] as num).toDouble(),
      unit: map['unit'] ?? 'pcs',
      hsnCode: map['hsn_code'],
      isService: (map['is_service'] == 1),
      createdAt: map['created_at'],
    );
  }
}
