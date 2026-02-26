import 'dart:convert';
import 'package:caja_inventario/core/utils/const.dart';
import 'package:http/http.dart' as http;

class MovementsService {
  static const String baseUrl = gBaseUrl;

  static Future<void> adjustStock(
    String id,
    double newStock,
    String? reason,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/$id/adjust'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'newStock': newStock, 'reason': reason}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al ajustar stock');
    }
  }

  static Future<void> wasteStock(
    String id,
    double quantity,
    String? reason,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/$id/waste'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({'quantity': quantity, 'reason': reason}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al registrar merma');
    }
  }
}
