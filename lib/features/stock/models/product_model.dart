class ProductModel {
  final String id;
  final String name;
  final String? description;

  final double salePrice;
  final double costPrice;

  final double stock;
  final double minStock;

  final String unit; //unitario, kilo, litro
  //final String? categoryID;

  final bool isActive;

  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description,

    required this.salePrice,
    required this.costPrice,

    required this.stock,
    required this.minStock,

    required this.unit,
    //this.categoryID,

    this.isActive = true,

    required this.createdAt,
    required this.updatedAt
  });

  bool get isLowStock => stock <= minStock;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? 'sin descripción',

      salePrice: (json['sale_price'] as num?)?.toDouble() ?? 0.0,
      costPrice: (json['cost_price'] as num?)?.toDouble() ?? 0.0,

      stock: (json['stock'] as num?)?.toDouble() ?? 0.0,
      minStock: (json['min_stock'] as num?)?.toDouble() ?? 0.0,

      unit: json['unit'],
      //categoryID: json['categoryID'],

      isActive: json['is_active'] ?? true,

      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,

      'sale_price': salePrice,
      'cost_price': costPrice,

      'stock': stock,
      'min_stock': minStock,

      'unit': unit,
      //'categoryID': categoryID,

      'is_active': isActive,

      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String()
    };
  }
}
