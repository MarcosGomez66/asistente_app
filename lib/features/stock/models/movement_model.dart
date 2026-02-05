class MovementModel {
  final String id;
  final String productId;

  final double quantity; // siempre positivo
  final String type; //IN, OUT, ADJUST

  final String? reason;
  final String? workdayId;

  final DateTime createdAt;

  MovementModel({
    required this.id,
    required this.productId,

    required this.quantity,
    required this.type,

    this.reason,
    this.workdayId,

    required this.createdAt
});

  factory MovementModel.fromJson(Map<String, dynamic> json) {
    return MovementModel(
        id: json['id'],
        productId: json['productId'],
        quantity: (json['quantity'] as num).toDouble(),
        type: json['type'],
        reason: json['reason'],
        workdayId: json['workdayId'],
        createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
      'type': type,
      'reason': reason,
      'workdayId': workdayId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isIn => type == 'IN';
  bool get isOut => type == 'OUT';

  String get label {
    switch (type) {
      case 'IN':
        return 'Ingreso';
      case 'Out':
        return 'Egreso';
      case 'ADJUST':
        return 'Ajuste';
      default:
        return 'Movimineto';
    }
  }
}